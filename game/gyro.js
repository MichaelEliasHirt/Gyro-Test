// web_gyro.js

// --- Gyroscope Data Storage ---
window.gyroAlpha = 0.0;
window.gyroBeta = 0.0;
window.gyroGamma = 0.0;

// --- Gyroscope Detection and Status Variables ---
window.hasDeviceOrientationEventSupport = false; // Is the API available in the browser?
window.needsGyroPermission = false;             // Does iOS 13+ permission need to be requested?
window.isGyroPermissionGranted = false;         // Has permission been granted by the user?
window.hasWorkingGyroscope = false;             // Have we received valid data after all checks?
window.debug = "nothing";

// A flag to prevent multiple permission prompts
window.isRequestingPermission = false;

// --- Event Listener Function ---
function onDeviceOrientationChange(event) {
    if (event.alpha !== null || event.beta !== null || event.gamma !== null) {
        // Valid data received, so the gyroscope is working!
        window.hasWorkingGyroscope = true;
        window.gyroAlpha = event.alpha;
        window.gyroBeta = event.beta;
        window.gyroGamma = event.gamma;
    } else {
        // Event fired, but data is null (e.g., sensor not active, or permission not granted yet)
        console.warn("DeviceOrientationEvent fired, but data is null. Waiting for active sensor/permission.");
        window.hasWorkingGyroscope = false; // Reset if data suddenly becomes null
    }
}

// --- Function to Request Permission (iOS 13+ specific) ---
window.requestGyroscopePermission = function () {
    if (window.needsGyroPermission && typeof DeviceOrientationEvent.requestPermission === 'function') {
        if (!window.isRequestingPermission) { // Prevent multiple requests
            window.isRequestingPermission = true;
            DeviceOrientationEvent.requestPermission()
                .then(permissionState => {
                    window.isRequestingPermission = false; // Reset flag
                    if (permissionState === 'granted') {
                        console.log("Gyroscope permission granted. Adding deviceorientation listener.");
                        window.isGyroPermissionGranted = true;
                        // Add the listener ONLY after permission is granted
                        window.addEventListener("deviceorientation", onDeviceOrientationChange, true);
                        window.debug = "it should work";
                    } else {
                        console.warn("Gyroscope permission denied.");
                        window.isGyroPermissionGranted = false;
                        window.hasWorkingGyroscope = false;
                        window.debug = "simply denied";
                    }
                })
                .catch(error => {
                    window.isRequestingPermission = false; // Reset flag
                    console.error("Error requesting gyroscope permission:", error);
                    window.isGyroPermissionGranted = false;
                    window.hasWorkingGyroscope = false;
                    window.debug = "an error has ocoured";
                });
        } else {
            console.log("Gyroscope permission request already in progress.");
            window.debug = "already in progress";
        }
    } else {
        console.log("DeviceOrientationEvent.requestPermission not required or not available.");
        // If permission isn't needed, and the API is supported, just add the listener
        if (window.hasDeviceOrientationEventSupport) {
            window.addEventListener("deviceorientation", onDeviceOrientationChange, true);
        }
    }
    // Return the state for immediate checking in Godot, though permission is async
    return window.isGyroPermissionGranted;
};

// --- Initial Setup and Check on Load ---
(function () {
    if (window.DeviceOrientationEvent) {
        window.hasDeviceOrientationEventSupport = true;
        console.log("DeviceOrientationEvent API is supported by the browser.");

        if (typeof DeviceOrientationEvent.requestPermission === 'function') {
            window.needsGyroPermission = true;
            console.log("iOS 13+ detected: Gyroscope permission will be needed.");
        } else {
            // No permission required (e.g., Android, older iOS).
            // Add the listener immediately and check if data flows.
            console.log("No explicit gyroscope permission needed. Adding listener.");
            window.addEventListener("deviceorientation", onDeviceOrientationChange, true);
        }
    } else {
        window.hasDeviceOrientationEventSupport = false;
        console.log("DeviceOrientationEvent API is NOT supported by this browser. No gyroscope functionality.");
    }
})();

console.log("web_gyro.js loaded successfully!");