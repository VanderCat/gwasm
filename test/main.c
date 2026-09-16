// Simple example: add two numbers
int add(int a, int b) {
    return a + b;
}
extern void msg();
// Main entry point
int app_main(void) {
    msg();
    int result = add(10, 20);
    return result;  // Returns 30
}