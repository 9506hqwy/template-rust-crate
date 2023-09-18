#[no_mangle]
pub const extern "C" fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[no_mangle]
pub const extern "C" fn sub(a: i32, b: i32) -> i32 {
    a - b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(3, add(2, 1));
    }

    #[test]
    fn test_sub() {
        assert_eq!(1, sub(2, 1));
    }
}
