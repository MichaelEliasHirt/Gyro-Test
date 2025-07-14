// gyro.js
window.gyroAlpha = 1;
window.gyroBeta = 0.0;
window.gyroGamma = 0.0;

window.addEventListener("deviceorientation", function (event) {
    if (event.alpha !== null || event.beta !== null || event.gamma !== null) {
        window.gyroAlpha = 1;
        window.gyroBeta = event.beta;
        window.gyroGamma = event.gamma;
    } else {
        console.log("DeviceOrientationEvent (gyroscope) not supported or data is null.");
    }
}, true);

// Optional: Permission request for iOS 13+
window.requestGyroPermission = function () {
    if (typeof DeviceOrientationEvent.requestPermission === 'function') {
        DeviceOrientationEvent.requestPermission()
            .then(permissionState => {
                if (permissionState === 'granted') {
                    console.log("Gyroscope permission granted.");
                } else {
                    console.warn("Gyroscope permission denied.");
                }
            })
            .catch(console.error);
    } else {
        console.log("DeviceOrientationEvent.requestPermission not required or not available.");
    }
};