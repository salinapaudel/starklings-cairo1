mod restaurant {
    pub fn take_order() -> &'static str {
        "order_taken"
    }
}

#[test]
fn test_mod_fn() {
    // Call the take_order function from the restaurant module
    let order_result = restaurant::take_order();

    assert!(order_result == "order_taken", "Order not taken");
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_super_fn() {
        // Call the take_order function from the restaurant module
        let order_result = super::restaurant::take_order();

        assert!(order_result == "order_taken", "Order not taken");
    }
}
