<?php
/**
 * post_dish_or_item.php
 * Handles posting dishes by chefs and items by grocers
 * Updated to match existing backend API structure
 */

// Start output buffering to catch any unwanted output
ob_start();

// Disable error display to prevent HTML output before JSON
ini_set("display_errors", 0);
ini_set("display_startup_errors", 0);
error_reporting(E_ALL); // Still log errors, just don't display them
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/post_dish_errors.log');

// Set JSON header first
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json; charset=utf-8');

// Helper function to send JSON response and exit
function sendJsonResponse($success, $message, $data = []) {
    // Clean any buffered output
    ob_end_clean();
    http_response_code($success ? 200 : 400);
    header('Content-Type: application/json; charset=utf-8');
    $response = [
        'success' => $success ? 'true' : 'false',
        'msg' => $message
    ];
    if (!empty($data)) {
        $response = array_merge($response, $data);
    }
    echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

// Error handler to catch fatal errors and return JSON
function handleFatalError() {
    $error = error_get_last();
    if ($error !== NULL && in_array($error['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR])) {
        ob_end_clean();
        header('Content-Type: application/json; charset=utf-8');
        http_response_code(500);
        echo json_encode([
            'success' => 'false',
            'msg' => 'Server error occurred. Please check server logs.',
            'error' => $error['message']
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }
}
register_shutdown_function('handleFatalError');

try {
    include('conn.php');
    include("function_app.php");
    include('notification_function.php');
    
    // Clear any output from included files
    ob_clean();
} catch (Exception $e) {
    error_log("post_dish_or_item.php: Error including files: " . $e->getMessage());
    sendJsonResponse(false, 'Server configuration error. Please contact support.');
}

// Helper function to get POST value (handles multipart form data)
// Must be defined outside try block so it's available everywhere
function getPostValue($key, $default = null) {
    // Try $_POST first
    if (isset($_POST[$key]) && $_POST[$key] !== '' && $_POST[$key] !== null && $_POST[$key] !== 'null') {
        error_log("post_dish_or_item.php: Found $key in \$_POST: " . $_POST[$key]);
        return $_POST[$key];
    }
    // Try $_REQUEST (sometimes multipart data ends up here)
    if (isset($_REQUEST[$key]) && $_REQUEST[$key] !== '' && $_REQUEST[$key] !== null && $_REQUEST[$key] !== 'null') {
        error_log("post_dish_or_item.php: Found $key in \$_REQUEST: " . $_REQUEST[$key]);
        return $_REQUEST[$key];
    }
    error_log("post_dish_or_item.php: Key $key not found in POST or REQUEST");
    return $default;
}

try {
    $date = date('Y-m-d H:i:s');

    // Enable error logging
    ini_set('log_errors', 1);
    ini_set('error_log', __DIR__ . '/post_dish_errors.log');

    // Check request method
    if (!($_SERVER['REQUEST_METHOD'] === 'POST')) {
        sendJsonResponse(false, 'Please use POST method !');
    }

    // Log request details for debugging
    error_log("post_dish_or_item.php: Content-Type: " . ($_SERVER['CONTENT_TYPE'] ?? 'not set'));
    error_log("post_dish_or_item.php: POST count: " . count($_POST));
    error_log("post_dish_or_item.php: POST keys: " . implode(', ', array_keys($_POST)));
    error_log("post_dish_or_item.php: POST data: " . json_encode($_POST));
    error_log("post_dish_or_item.php: FILES count: " . count($_FILES));
    error_log("post_dish_or_item.php: REQUEST count: " . count($_REQUEST));
    error_log("post_dish_or_item.php: REQUEST keys: " . implode(', ', array_keys($_REQUEST)));
    error_log("post_dish_or_item.php: REQUEST data: " . json_encode($_REQUEST));
    
    // CRITICAL FIX: For multipart requests with files, PHP may not populate $_POST correctly
    // We need to manually extract form fields from the multipart body
    if (!empty($_FILES)) {
        error_log("post_dish_or_item.php: FILES detected, checking for form data");
        
        // CRITICAL: Copy ALL form fields from $_REQUEST to $_POST
        // PHP doesn't populate $_POST correctly with multipart/form-data + files
        if (!empty($_REQUEST)) {
            error_log("post_dish_or_item.php: \$_REQUEST has " . count($_REQUEST) . " items: " . implode(', ', array_keys($_REQUEST)));
            foreach ($_REQUEST as $req_key => $req_value) {
                // Skip file-related keys and arrays, only copy form fields
                if (!isset($_FILES[$req_key]) && 
                    $req_key !== 'images' && 
                    $req_key !== 'images[]' &&
                    !is_array($req_value) &&
                    $req_value !== '' &&
                    $req_value !== null &&
                    $req_value !== 'null') {
                    // FORCE overwrite POST with REQUEST values for multipart requests
                    $_POST[$req_key] = $req_value;
                    error_log("post_dish_or_item.php: FORCED copy $req_key = '$req_value' from REQUEST to POST");
                }
            }
            error_log("post_dish_or_item.php: After merge, \$_POST has " . count($_POST) . " items: " . implode(', ', array_keys($_POST)));
        } else {
            error_log("post_dish_or_item.php: WARNING - \$_REQUEST is empty even though FILES exist!");
        }
        
        // If still no data in $_POST, try parsing from Content-Type boundary
        if (empty($_POST) && isset($_SERVER['CONTENT_TYPE']) && strpos($_SERVER['CONTENT_TYPE'], 'multipart') !== false) {
            error_log("post_dish_or_item.php: POST still empty, attempting manual multipart parse");
            // Note: php://input is empty after PHP processes multipart, so we can't use it here
            // But $_REQUEST should have the data if PHP processed it correctly
        }
        
        error_log("post_dish_or_item.php: Final POST keys after processing: " . implode(', ', array_keys($_POST)));
        error_log("post_dish_or_item.php: Final POST values: " . json_encode($_POST));
    }

// Validate required fields - try multiple sources
$user_id = null;

// Method 1: Direct from $_POST
if (isset($_POST['user_id']) && !empty($_POST['user_id']) && $_POST['user_id'] !== 'null') {
    $user_id = $_POST['user_id'];
    error_log("post_dish_or_item.php: Found user_id in \$_POST: $user_id");
}
// Method 2: From $_REQUEST
elseif (isset($_REQUEST['user_id']) && !empty($_REQUEST['user_id']) && $_REQUEST['user_id'] !== 'null') {
    $user_id = $_REQUEST['user_id'];
    $_POST['user_id'] = $user_id; // Set in POST for consistency
    error_log("post_dish_or_item.php: Found user_id in \$_REQUEST: $user_id, copied to \$_POST");
}
// Method 3: Use helper function
else {
    $user_id = getPostValue('user_id');
}

if (empty($user_id)) {
    error_log("post_dish_or_item.php: ERROR - user_id is EMPTY after all attempts!");
    error_log("post_dish_or_item.php: \$_POST count: " . count($_POST) . ", keys: " . implode(', ', array_keys($_POST)));
    error_log("post_dish_or_item.php: \$_POST data: " . json_encode($_POST));
    error_log("post_dish_or_item.php: \$_REQUEST count: " . count($_REQUEST) . ", keys: " . implode(', ', array_keys($_REQUEST)));
    error_log("post_dish_or_item.php: \$_REQUEST data: " . json_encode($_REQUEST));
    error_log("post_dish_or_item.php: \$_FILES count: " . count($_FILES) . ", keys: " . implode(', ', array_keys($_FILES)));
    error_log("post_dish_or_item.php: Content-Type: " . ($_SERVER['CONTENT_TYPE'] ?? 'not set'));
    error_log("post_dish_or_item.php: Request Method: " . ($_SERVER['REQUEST_METHOD'] ?? 'not set'));
    sendJsonResponse(false, 'Please send user id!!');
}

// Get all POST values using helper function
$name = getPostValue('name');
$price = getPostValue('price');
$type = getPostValue('type');
$description = getPostValue('description');
$service_type = getPostValue('service_type');
$meal = getPostValue('meal');
$dish_date = getPostValue('dish_date');
$start_time_raw = getPostValue('start_time');
$end_time_raw = getPostValue('end_time');
$category_id = getPostValue('category_id');
$portion = getPostValue('portion');
$criteria = getPostValue('criteria');

if (empty($name)) {
    sendJsonResponse(false, 'Please send name!!');
}

if (empty($price)) {
    sendJsonResponse(false, 'Please send price!!');
}

if (empty($description)) {
    sendJsonResponse(false, 'Please send description!!');
}

if (empty($type)) {
    sendJsonResponse(false, 'Please send type!!');
}

if (empty($service_type)) {
    sendJsonResponse(false, 'Please send service_type!!');
}

// Fix URL construction - ensure proper https:// or http:// format
$protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off' ? 'https://' : 'http://';
$url = $protocol . $_SERVER['HTTP_HOST'] . dirname($_SERVER['PHP_SELF']);

// Helper function to generate random string
function generateRandomString($length = 10) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, strlen($characters) - 1)];
    }
    return $randomString;
}

//--------------------------------------------check user_id-----------------------//
$ac = 'yes';
$check_user_id = $mysqli->prepare("select user_id,first_name,active_flag FROM `user_master` where user_id=? and  (user_type='chef' or user_type='grocer')");
$check_user_id->bind_param("i", $user_id);
$check_user_id->execute();
$check_user_id->store_result();

if ($check_user_id->num_rows <= 0) {
    sendJsonResponse(false, 'No user found', ['status' => 'no_user']);
}

$check_user_id->bind_result($user_id, $first_name, $admin_active_flag);
$check_user_id->fetch();

if ($admin_active_flag == 'no') {
    sendJsonResponse(false, 'Your account deactivated by admin', ['status' => 'no_user']);
}

$update = $mysqli->prepare("Update `user_master` set `insert_time`=? Where `user_id`=?");
$update->bind_param("si", $date, $user_id);
$update->execute();

//-------------------------------------------check user_id end---------------------//

//-------------------------------------------send item---------------------//
if ($type == 'grocer') {
    //--------------------------------check dish exist-----------------------------------
    $check_already = $mysqli->prepare("select dish_id from dish_master where user_id=? and name=? and price=? and description=? and type=?");
    $check_already->bind_param("issss", $user_id, $name, $price, $description, $type);
    $check_already->execute();
    $check_already->store_result();

    if ($check_already->num_rows > 0) {
        sendJsonResponse(false, 'Dish already available');
    }

    $insert = $mysqli->prepare("INSERT INTO `dish_master`(`user_id`, `name`, `service_type`, `price`, `description`, `type`, `inserttime`) VALUES (?,?,?,?,?,?,?)");
    $insert->bind_param("issssss", $user_id, $name, $service_type, $price, $description, $type, $date);
    $insert->execute();
    $i4 = $insert->affected_rows;

    if ($i4 <= 0) {
        sendJsonResponse(false, 'Dish not post');
    } else {
        $last_id = $insert->insert_id;
        $dish_id_noti = $last_id;

        //-------------------------------------------insert image-------------------------------------
        if (!empty($_FILES['images']['name'])) {
            foreach ($_FILES['images']['name'] as $i => $name3) {
                $filename = stripslashes($_FILES['images']['name'][$i]);
                $str = generateRandomString();
                $str2 = rand();
                $str3 = $str . $str2;
                $filename = $str3 . basename($_FILES['images']['name'][$i]);
                $filename = trim($_FILES['images']['name'][$i]); //rename file
                $filename = str_replace(' ', '_', $filename);
                $filename = $str3 . $filename;
                $target = "images/";
                $databasename1 = $url . "/images/" . $filename;

                if (move_uploaded_file($_FILES['images']['tmp_name'][$i], $target . $filename)) {
                    $insert_img = $mysqli->prepare("INSERT INTO `dish_image_master`(`dish_id`, `image`, `inserttime`) VALUES (?,?,?)");
                    $insert_img->bind_param("sss", $last_id, $databasename1, $date);
                    $insert_img->execute();
                    $i5 = $insert_img->affected_rows;

                    if ($i5 <= 0) {
                        $delete_dish = $mysqli->prepare("delete from dish_master where dish_id=?");
                        $delete_dish->bind_param("i", $last_id);
                        $delete_dish->execute();
                        $delete_dishimage = $mysqli->prepare("delete from dish_image_master where dish_id=?");
                        $delete_dishimage->bind_param("i", $last_id);
                        $delete_dishimage->execute();

                        sendJsonResponse(false, 'image not inserted');
                    }
                } else {
                    $delete_dish = $mysqli->prepare("delete from dish_master where dish_id=?");
                    $delete_dish->bind_param("i", $last_id);
                    $delete_dish->execute();
                    $delete_dishimage = $mysqli->prepare("delete from dish_image_master where dish_id=?");
                    $delete_dishimage->bind_param("i", $last_id);
                    $delete_dishimage->execute();

                    sendJsonResponse(false, 'image not uploaded');
                }
            }
        }
        //-------------------------------------------insert image end----------------------------------

        /*-----------------------notification for all user------------------------------------*/
        //----------------------------get all user----------------------------------------
        $ut = 'buyer';
        $user_type_noti = $type;
        $active = 'yes';
        $delete = 'no';

        $get_user_all = $mysqli->prepare("select from_user_id from following_master where to_user_id=?");
        $get_user_all->bind_param("i", $user_id);
        $get_user_all->execute();
        $get_user_all->store_result();
        $get_user_all->bind_result($auser_id);

        while ($get_user_all->fetch()) {
            $message = $first_name . " recently posted " . $name;
            $action = 'dish_update';
            $title = 'Post Dish';

            $message_json = json_encode(array(
                'user_id' => $user_id,
                'other_user_id' => $auser_id,
                'dish_id' => $dish_id_noti,
                'user_type' => $user_type_noti
            ));

            $insert_status = InsertNotificationJson($user_id, $auser_id, $action, $title, $message, $message_json);
            $player_id = get_player_id($auser_id);

            if ($player_id != 'NA') {
                $user_json = array(
                    'user_id' => $user_id,
                    'page_name' => 'home',
                    'user_type' => $type,
                    'post_id' => $last_id
                );
                send_notification_with_parameter($player_id, $title, $message, $user_json);
            }
        }

        sendJsonResponse(true, 'Dish posted successfully');
    }
    }
//-------------------------------------------send item end ----------------//

if ($type == 'chef') {
    if (empty($meal)) {
        sendJsonResponse(false, 'Please send meal!!');
    }

    if (empty($dish_date)) {
        sendJsonResponse(false, 'Please send dish_date!!');
    }

    if (empty($start_time_raw)) {
        sendJsonResponse(false, 'Please send start_time!!');
    }

    if (empty($end_time_raw)) {
        sendJsonResponse(false, 'Please send end_time!!');
    }

    if (empty($category_id)) {
        sendJsonResponse(false, 'Please send category_id!!');
    }

    if (empty($portion)) {
        sendJsonResponse(false, 'Please send portion per user!!');
    }

    if (empty($criteria)) {
        sendJsonResponse(false, 'Please send criteria !!');
    }

    $start_time = date('H:i:s', strtotime($start_time_raw));
    $end_time = date('H:i:s', strtotime($end_time_raw));

    //--------------------------------check dish exist-----------------------------------
    if ($price == 'undefined' || empty($price)) {
        $price = "150";
    }

    $check_already = $mysqli->prepare("select dish_id from dish_master where user_id=? and name=? and meal=? and service_type=? and category_id=? and price=? and description=? and type=? and start_time=? and end_time=? and `portion`=?");
    $check_already->bind_param("issssssssss", $user_id, $name, $meal, $service_type, $category_id, $price, $description, $type, $start_time, $end_time, $portion);
    $check_already->execute();
    $check_already->store_result();

    if ($check_already->num_rows > 0) {
        sendJsonResponse(false, 'Dish already available');
    }

    $insert = $mysqli->prepare("INSERT INTO `dish_master`(`user_id`,`name`, `meal`, service_type, category_id, dish_date, start_time, end_time, `portion`, `price`, `description`, `type`, `inserttime`,`criteria`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
    $insert->bind_param("isssisssssssss", $user_id, $name, $meal, $service_type, $category_id, $dish_date, $start_time, $end_time, $portion, $price, $description, $type, $date, $criteria);
    $insert->execute();
    $i4 = $insert->affected_rows;

    if ($i4 <= 0) {
        sendJsonResponse(false, 'Dish not post');
    } else {
        $last_id = $insert->insert_id;
        $dish_id_noti = $last_id;

        //-------------------------------------------insert image-------------------------------------
        if (!empty($_FILES['images']['name'])) {
            foreach ($_FILES['images']['name'] as $i => $name3) {
                $filename = stripslashes($_FILES['images']['name'][$i]);
                $str = generateRandomString();
                $str2 = rand();
                $str3 = $str . $str2;
                $filename = $str3 . basename($_FILES['images']['name'][$i]);
                $filename = trim($_FILES['images']['name'][$i]); //rename file
                $filename = str_replace(' ', '_', $filename);
                $filename = $str3 . $filename;
                $target = "images/";
                $databasename1 = $url . "/images/" . $filename;

                if (move_uploaded_file($_FILES['images']['tmp_name'][$i], $target . $filename)) {
                    $insert_img = $mysqli->prepare("INSERT INTO `dish_image_master`(`dish_id`, `image`, `inserttime`) VALUES (?,?,?)");
                    $insert_img->bind_param("sss", $last_id, $databasename1, $date);
                    $insert_img->execute();
                    $i5 = $insert_img->affected_rows;

                    if ($i5 <= 0) {
                        $delete_dish = $mysqli->prepare("delete from dish_master where dish_id=?");
                        $delete_dish->bind_param("i", $last_id);
                        $delete_dish->execute();
                        $delete_dishimage = $mysqli->prepare("delete from dish_image_master where dish_id=?");
                        $delete_dishimage->bind_param("i", $last_id);
                        $delete_dishimage->execute();

                        sendJsonResponse(false, 'image not inserted');
                    }
                } else {
                    $delete_dish = $mysqli->prepare("delete from dish_master where dish_id=?");
                    $delete_dish->bind_param("i", $last_id);
                    $delete_dish->execute();
                    $delete_dishimage = $mysqli->prepare("delete from dish_image_master where dish_id=?");
                    $delete_dishimage->bind_param("i", $last_id);
                    $delete_dishimage->execute();

                    sendJsonResponse(false, 'image not uploaded');
                }
            }
        }
        //-------------------------------------------insert image end----------------------------------

        /*-----------------------notification for all user------------------------------------*/
        //----------------------------get all user----------------------------------------
        $ut = 'buyer';
        $user_type_noti = $type;
        $active = 'yes';
        $delete = 'no';

        $get_user_all = $mysqli->prepare("select from_user_id from following_master where to_user_id=?");
        $get_user_all->bind_param("i", $user_id);
        $get_user_all->execute();
        $get_user_all->store_result();
        $get_user_all->bind_result($auser_id);

        while ($get_user_all->fetch()) {
            $message = $first_name . " recently posted " . $name;
            $action = 'dish_update';
            $title = 'Post Dish';

            $message_json = json_encode(array(
                'user_id' => $user_id,
                'other_user_id' => $auser_id,
                'dish_id' => $dish_id_noti,
                'user_type' => $user_type_noti
            ));

            $insert_status = InsertNotificationJson($user_id, $auser_id, $action, $title, $message, $message_json);
            $player_id = get_player_id($auser_id);

            if ($player_id != 'NA') {
                $user_json = array(
                    'user_id' => $user_id,
                    'page_name' => 'home',
                    'user_type' => $type,
                    'post_id' => $last_id
                );
                send_notification_with_parameter($player_id, $title, $message, $user_json);
            }
        }

        if ($type == 'chef') {
            $msg = 'Dish posted successfully';
        } else {
            $msg = 'Item posted successfully';
        }

        sendJsonResponse(true, $msg);
    }
    }
} catch (Exception $e) {
    error_log("post_dish_or_item.php: Unexpected error: " . $e->getMessage() . " | Trace: " . $e->getTraceAsString());
    sendJsonResponse(false, 'An unexpected error occurred. Please try again.');
} catch (Throwable $e) {
    error_log("post_dish_or_item.php: Fatal error: " . $e->getMessage() . " | Trace: " . $e->getTraceAsString());
    sendJsonResponse(false, 'A server error occurred. Please check server logs.');
}

// If we reach here, something went wrong
sendJsonResponse(false, 'Request could not be processed.');
?>
