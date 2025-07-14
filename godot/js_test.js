// test_bridge.js

// 1. A simple global variable to set/get
window.myGlobalJsVariable = "Hello from JavaScript!";

// 2. A simple global function to call, which can return a value
window.getGreeting = function () {
    console.log("getGreeting() function called from Godot!");
    return "Greetings from JS!";
};

// 3. A function that takes arguments and returns a result
window.addNumbers = function (a, b) {
    console.log("addNumbers() called with:", a, b);
    return a + b;
};

// 4. A function that can manipulate a Godot-set variable (less common for direct eval,
//    more for Godot calling JS to update a DOM element, etc.)
window.updateGodotMessage = function (newMessage) {
    console.log("JavaScript received message for Godot:", newMessage);
    // In a real scenario, you'd update a DOM element here or trigger a Godot callback
    // For eval, we usually just return values.
    // If you need Godot to be notified, you'd typically use JavaScriptBridge.create_callback
    // and pass it to JS, or have JS call back to a C++ GDExtension function.
};

console.log("test_bridge.js loaded successfully!");