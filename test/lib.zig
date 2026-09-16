export fn add(a: i32, b: i32) i64 {
    return a + b;
}
extern fn msg() void;
pub fn main() u8 {
    msg(); // should print something in console
    return 0;
}