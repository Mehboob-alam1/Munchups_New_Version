# Dish Fetch Verification Guide

## Overview
After posting dishes using `post_dish_or_item.php`, the dishes need to be fetched and displayed in:
1. **Buyer Home Screen** - via `getall_chef_or_grocer_with_detail.php`
2. **Chef/Grocer Profile** - via `get_profile.php` (in `all_post` field)

## Backend APIs That Need to Include Dishes

### 1. `get_profile.php` - For Chef/Grocer to see their own dishes

**What it should do:**
- Query `dish_master` table to get all dishes for the user
- Join with `dish_image_master` to get dish images
- Include dishes in the `all_post` field of the response

**Expected SQL Query Pattern:**
```sql
SELECT 
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
    dm.inserttime,
    GROUP_CONCAT(dim.image ORDER BY dim.dish_image_id) as dish_images
FROM dish_master dm
LEFT JOIN dish_image_master dim ON dm.dish_id = dim.dish_id
WHERE dm.user_id = ? 
    AND dm.type = ? -- 'chef' or 'grocer'
GROUP BY dm.dish_id
ORDER BY dm.inserttime DESC
```

**Response Format:**
The `all_post` field should be an array of dishes, each with:
```json
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
  "dish_images": [
    {
      "dish_image_id": 1,
      "image": "https://munchups.com/webservice/images/filename.jpg"
    }
  ]
}
```

### 2. `getall_chef_or_grocer_with_detail.php` - For Buyers to see chefs/grocers with dishes

**What it should do:**
- Query `user_master` to get chefs/grocers
- For each chef/grocer, query `dish_master` to get their dishes
- Join with `dish_image_master` to get dish images
- Include dishes in the response for each chef/grocer

**Expected SQL Query Pattern:**
```sql
-- First, get chefs/grocers
SELECT 
    um.user_id,
    um.first_name,
    um.last_name,
    um.image,
    um.user_type,
    -- ... other user fields
FROM user_master um
WHERE um.user_type IN ('chef', 'grocer')
    AND um.active_flag = 'yes'
    AND um.delete_flag = 'no'
    -- Add location filter if provided
ORDER BY um.insert_time DESC

-- Then for each chef/grocer, get their dishes
SELECT 
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
    GROUP_CONCAT(dim.image ORDER BY dim.dish_image_id) as dish_images
FROM dish_master dm
LEFT JOIN dish_image_master dim ON dm.dish_id = dim.dish_id
WHERE dm.user_id = ? -- chef/grocer user_id
GROUP BY dm.dish_id
ORDER BY dm.inserttime DESC
```

**Response Format:**
Each chef/grocer should have an `all_dish` or similar field with their dishes:
```json
{
  "success": "true",
  "chefs": [
    {
      "user_id": 118,
      "first_name": "John",
      "user_type": "chef",
      "all_dish": [
        {
          "dish_id": 123,
          "dish_name": "Test dish",
          "dish_price": "120",
          "dish_description": "Test dish description",
          "dish_images": [...]
        }
      ]
    }
  ]
}
```

## Table Structure Reference

### `dish_master` table
- `dish_id` (INT, PRIMARY KEY, AUTO_INCREMENT)
- `user_id` (INT) - Foreign key to `user_master.user_id`
- `name` (VARCHAR) - Dish name
- `service_type` (VARCHAR) - 'Collection' or 'Delivery'
- `price` (DECIMAL) - Dish price
- `description` (TEXT) - Dish description
- `type` (VARCHAR) - 'chef' or 'grocer'
- `meal` (VARCHAR) - 'breakfast', 'lunch', 'dinner' (for chef only)
- `dish_date` (DATE) - Serving date (for chef only)
- `start_time` (TIME) - Start time (for chef only)
- `end_time` (TIME) - End time (for chef only)
- `category_id` (INT) - Food category (for chef only)
- `portion` (INT) - Portions per user (for chef only)
- `criteria` (VARCHAR) - Delivery range (for chef only)
- `inserttime` (TIMESTAMP) - Creation timestamp

### `dish_image_master` table
- `dish_image_id` (INT, PRIMARY KEY, AUTO_INCREMENT)
- `dish_id` (INT) - Foreign key to `dish_master.dish_id`
- `image` (VARCHAR) - Full URL to the image
- `inserttime` (TIMESTAMP) - Creation timestamp

## Verification Steps

1. **Test Chef Profile:**
   - Login as a chef
   - Post a dish using the app
   - Go to "Posted Dishes" screen
   - Verify the dish appears in the list

2. **Test Grocer Profile:**
   - Login as a grocer
   - Post an item using the app
   - Go to home screen
   - Verify the item appears in the list

3. **Test Buyer Home:**
   - Login as a buyer (or use guest mode)
   - Go to home screen
   - Verify chefs/grocers appear with their dishes
   - Click on a chef/grocer profile
   - Verify their dishes are visible

## Common Issues

### Issue: Dishes not appearing in `all_post`
**Solution:** Check that `get_profile.php` queries `dish_master` table and includes results in `all_post` field.

### Issue: Dishes not appearing for buyers
**Solution:** Check that `getall_chef_or_grocer_with_detail.php` queries `dish_master` for each chef/grocer and includes dishes in the response.

### Issue: Images not showing
**Solution:** 
- Verify `dish_image_master` table has records for the dish
- Check that image URLs are complete (include domain)
- Verify `images/` folder exists and is accessible

### Issue: Old dishes still showing, new ones not
**Solution:**
- Clear app cache or refresh data
- Check that `inserttime` is being used in ORDER BY clause
- Verify new dishes are being inserted with correct `user_id`

## Notes

- Dishes are saved with `inserttime` timestamp, so queries should order by `inserttime DESC` to show newest first
- Images are stored in `images/` folder (not `uploads/dishes/`)
- Image URLs should be full URLs like `https://munchups.com/webservice/images/filename.jpg`
- The `type` field in `dish_master` should match the user's `user_type` ('chef' or 'grocer')


