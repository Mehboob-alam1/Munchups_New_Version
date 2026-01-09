<?php
/**
 * CODE SNIPPET TO ADD TO get_profile.php
 * 
 * This code should be added to your existing get_profile.php file
 * to fetch dishes from dish_master table and include them in the all_post field
 * 
 * Add this code AFTER you fetch the user profile data and BEFORE you return the response
 */

// Function to fetch dishes for a user
function getDishesForUser($mysqli, $user_id, $user_type) {
    $dishes = array();
    
    // Query to get dishes with images
    $query = "SELECT 
                dm.dish_id,
                dm.name as dish_name,
                dm.price as dish_price,
                dm.description as dish_description,
                dm.meal,
                dm.service_type,
                dm.dish_date,
                dm.start_time,
                dm.end_time,
                dm.category_id,
                dm.portion,
                dm.criteria,
                dm.type,
                dm.inserttime
              FROM dish_master dm
              WHERE dm.user_id = ? AND dm.type = ?
              ORDER BY dm.inserttime DESC";
    
    $stmt = $mysqli->prepare($query);
    if ($stmt) {
        $stmt->bind_param("is", $user_id, $user_type);
        $stmt->execute();
        $result = $stmt->get_result();
        
        while ($row = $result->fetch_assoc()) {
            $dish_id = $row['dish_id'];
            
            // Get images for this dish
            $image_query = "SELECT dish_image_id, image 
                           FROM dish_image_master 
                           WHERE dish_id = ? 
                           ORDER BY dish_image_id ASC";
            $img_stmt = $mysqli->prepare($image_query);
            $images = array();
            
            if ($img_stmt) {
                $img_stmt->bind_param("i", $dish_id);
                $img_stmt->execute();
                $img_result = $img_stmt->get_result();
                
                while ($img_row = $img_result->fetch_assoc()) {
                    $images[] = array(
                        'dish_image_id' => $img_row['dish_image_id'],
                        'kitchen_image' => $img_row['image']
                    );
                }
                $img_stmt->close();
            }
            
            // Format dish data to match expected structure
            $dish = array(
                'dish_id' => $row['dish_id'],
                'dish_name' => $row['dish_name'],
                'dish_price' => $row['dish_price'],
                'dish_description' => $row['dish_description'],
                'meal' => $row['meal'] ?? null,
                'service_type' => $row['service_type'],
                'dish_date' => $row['dish_date'] ?? null,
                'start_time' => $row['start_time'] ?? null,
                'end_time' => $row['end_time'] ?? null,
                'category_id' => $row['category_id'] ?? null,
                'portion' => $row['portion'] ?? null,
                'criteria' => $row['criteria'] ?? null,
                'type' => $row['type'],
                'inserttime' => $row['inserttime'],
                'dish_images' => $images
            );
            
            $dishes[] = $dish;
        }
        $stmt->close();
    }
    
    return $dishes;
}

// USAGE IN get_profile.php:
// 
// After you fetch the user profile data, add this:
//
// $user_id = $_GET['user_id']; // or however you get it
// $user_type = $_GET['user_type']; // 'chef' or 'grocer'
//
// // Fetch dishes for this user
// $dishes = getDishesForUser($mysqli, $user_id, $user_type);
//
// // Add dishes to profile_data
// if (isset($profile_data)) {
//     $profile_data['all_post'] = $dishes;
//     // Or if all_post already exists and you want to merge:
//     // $profile_data['all_post'] = array_merge($profile_data['all_post'] ?? [], $dishes);
// }
//
// // Then return the response as usual
// $record = array(
//     'success' => 'true',
//     'msg' => 'Profile fetched successfully',
//     'profile_data' => $profile_data
// );
// echo json_encode($record);

?>


