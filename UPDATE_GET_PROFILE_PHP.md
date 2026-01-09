# How to Update get_profile.php to Show Posted Dishes

## Problem
After posting dishes using `post_dish_or_item.php`, the dishes are not appearing in the "Posted Dishes" page because `get_profile.php` doesn't include dishes from the `dish_master` table.

## Solution
Add code to `get_profile.php` to query `dish_master` and `dish_image_master` tables and include the dishes in the `all_post` field of the response.

## Step-by-Step Instructions

### 1. Open `get_profile.php` on your server

### 2. Find where the profile data is being prepared for the response
Look for code like:
```php
$profile_data = array(
    'user_id' => ...,
    'first_name' => ...,
    // ... other profile fields
);
```

### 3. Add this code BEFORE the response is returned

```php
// Get user_id and user_type from request
$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : 0;
$user_type = isset($_GET['user_type']) ? trim($_GET['user_type']) : '';

// Fetch dishes for this user
$dishes = array();
if ($user_id > 0 && in_array($user_type, ['chef', 'grocer'])) {
    // Query to get dishes
    $dish_query = "SELECT 
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
    
    $dish_stmt = $mysqli->prepare($dish_query);
    if ($dish_stmt) {
        $dish_stmt->bind_param("is", $user_id, $user_type);
        $dish_stmt->execute();
        $dish_result = $dish_stmt->get_result();
        
        while ($dish_row = $dish_result->fetch_assoc()) {
            $dish_id = $dish_row['dish_id'];
            
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
            
            // Format dish data
            $dish = array(
                'dish_id' => $dish_row['dish_id'],
                'dish_name' => $dish_row['dish_name'],
                'dish_price' => $dish_row['dish_price'],
                'dish_description' => $dish_row['dish_description'],
                'meal' => $dish_row['meal'],
                'service_type' => $dish_row['service_type'],
                'dish_date' => $dish_row['dish_date'],
                'start_time' => $dish_row['start_time'],
                'end_time' => $dish_row['end_time'],
                'category_id' => $dish_row['category_id'],
                'portion' => $dish_row['portion'],
                'criteria' => $dish_row['criteria'],
                'type' => $dish_row['type'],
                'inserttime' => $dish_row['inserttime'],
                'dish_images' => $images
            );
            
            $dishes[] = $dish;
        }
        $dish_stmt->close();
    }
}

// Add dishes to profile_data
if (isset($profile_data)) {
    $profile_data['all_post'] = $dishes;
} else {
    // If profile_data doesn't exist, create it
    $profile_data = array(
        'all_post' => $dishes
    );
}
```

### 4. Make sure the response includes profile_data with all_post

Your response should look like:
```php
$record = array(
    'success' => 'true',
    'msg' => 'Profile fetched successfully',
    'profile_data' => $profile_data  // This should include 'all_post' with dishes
);
echo json_encode($record);
```

## Expected Response Format

The `get_profile.php` should return:
```json
{
  "success": "true",
  "msg": "Profile fetched successfully",
  "profile_data": {
    "user_id": 118,
    "first_name": "John",
    "user_type": "chef",
    "all_post": [
      {
        "dish_id": 123,
        "dish_name": "Test dish",
        "dish_price": "120",
        "dish_description": "Test dish description",
        "meal": "breakfast",
        "service_type": "Collection",
        "dish_date": "2026-01-07",
        "start_time": "13:00:00",
        "end_time": "13:00:00",
        "category_id": "7",
        "portion": "7",
        "criteria": "7",
        "type": "chef",
        "inserttime": "2026-01-07 13:00:00",
        "dish_images": [
          {
            "dish_image_id": 1,
            "kitchen_image": "https://munchups.com/webservice/images/filename.jpg"
          }
        ]
      }
    ]
  }
}
```

## Testing

1. **Post a dish** using the app (as chef or grocer)
2. **Go to "Posted Dishes" page** in the app
3. **Verify the dish appears** in the list
4. **Check the images** - they should load correctly

## Troubleshooting

### Dishes still not showing
- Check that `dish_master` table has records with the correct `user_id` and `type`
- Verify the SQL query is executing without errors
- Check PHP error logs on the server

### Images not showing
- Verify `dish_image_master` table has records for the dish
- Check that image URLs are complete (include full domain)
- Verify `images/` folder exists and is accessible

### Wrong data format
- Make sure field names match exactly (e.g., `dish_name`, not `name`)
- Verify `dish_images` is an array of objects with `kitchen_image` field
- Check that all required fields are included

## Notes

- The code uses prepared statements to prevent SQL injection
- Dishes are ordered by `inserttime DESC` to show newest first
- Images are ordered by `dish_image_id ASC` to maintain upload order
- The code handles both 'chef' and 'grocer' types


