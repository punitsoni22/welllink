# Implementation Plan for Hospital and Doctor Image Upload

## Required Dependencies
- `image_picker`: For selecting images from gallery or camera
- `firebase_storage`: For storing images in Firebase Storage

## Files to Modify

### 1. pubspec.yaml
- Add image_picker and firebase_storage dependencies

### 2. Hospital Implementation

#### hospital_controller.dart
- Add image file variable to track selected image
- Add method to pick image from gallery/camera
- Update addHospital method to upload image to Firebase Storage
- Update the imageUrl field in hospital data

#### add_hospital_view.dart
- Add image picker UI component
- Show selected image preview
- Connect to controller methods

### 3. Doctor Implementation

#### doctor_controller.dart
- Add image file variable to track selected image
- Add method to pick image from gallery/camera
- Update addDoctor method to upload image to Firebase Storage
- Update the imageUrl field in doctor data

#### add_doctor_view.dart
- Add image picker UI component
- Show selected image preview
- Connect to controller methods

## Implementation Steps

1. Update pubspec.yaml with new dependencies
2. Implement hospital image upload functionality
3. Implement doctor image upload functionality
4. Test both implementations

## Notes
- Image upload will be optional
- Default placeholder images will be used if no image is selected
- Firebase Storage rules should be configured to allow image uploads