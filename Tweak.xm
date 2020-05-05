@interface CAMViewfinderViewController
- (NSInteger)_currentMode;
@end

@interface CAMZoomControl : UIView
- (id)_findNearestViewController;
- (void)setHidden:(BOOL)arg1;
- (void)_handleButtonTappedForTripleCameraMode:(id)arg1;
@end

NSInteger cameraMode;

%hook CAMCaptureCapabilities

// Enables iP11 UI
- (BOOL)deviceSupportsCTM {
	return 1;
}

- (BOOL)isCTMSupported {
	return 1;
}

// Enables zoom platter controls
- (BOOL)isTripleCameraSupported {
	return 1;
}

- (BOOL)isBackTripleCameraSupported {
	return 1;
}

// Zooms out to 1x by default
// Otherwise it will zoom to 2x
- (double)defaultZoomFactorForMode:(long long)arg1 device:(long long)arg2 videoConfiguration:(long long)arg3 captureOrientation:(long long)arg4 {
	return 1;
}

%end

%hook CAMZoomControl

// Sets new zoom factors on capture mode change
- (void)_configureForControlMode:(long long)arg1 zoomFactor:(double)arg2 zoomFactors:(id)arg3 displayZoomFactors:(id)arg4 zoomButtonContentType:(long long)arg5 animated:(BOOL)arg6 {
	
	cameraMode = [[self _findNearestViewController] _currentMode]; // Gets current capture mode from parent ViewController
[self setHidden:0];

	// Sets zoom factors depending on camera mode
	switch(cameraMode) {
   	case 0 : // Photo mode
		arg3 = @[@1, @2, @3, @10];
		arg4 = @[@1, @2, @3, @10];
   	  	break;
   	case 1 : // Video mode	
   	case 2 : // Slo-mo mode
		arg3 = @[@1, @2, @3, @6];
		arg4 = @[@1, @2, @3, @6];	
   	  	break;
   	case 6 : // Portrait mode
		[self setHidden:1];
   	  	break;
	}
	
	%orig;
	
}

- (BOOL)_isButtonPlatterSupportedForConfiguration {

	if (cameraMode == 0 | cameraMode == 1 | cameraMode == 2) {
		return true; // Enables zoom platter controls for photo, video, and slo-mo mode
	} else {
		return false;
	}

}

- (void)_handleButtonTapped:(id)arg1 {

	if (cameraMode == 0 | cameraMode == 1 | cameraMode == 2) {
		[self _handleButtonTappedForTripleCameraMode:arg1]; // Fixes platter controls
	} else {
		%orig;
	}

}

%end