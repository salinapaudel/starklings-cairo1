use debug::PrintTrait;
const YEAR: u16 = 2050;

#[derive(Debug)]
struct Order {
    name: felt252,  // Define the type felt252
    year: u16,
    made_by_phone: bool,
    made_by_email: bool,
    item: felt252,  // Define the type felt252
}

mod order {
    use super::*;  // Import symbols from the parent module

    pub fn new_order(name: felt252, made_by_phone: bool, item: felt252) -> Order {
        Order {
            name,
            year: YEAR,
            made_by_phone,
            made_by_email: !made_by_phone,
            item,
        }
    }
}

mod order_utils {
    use super::*;
    
    pub fn dummy_phoned_order(name: felt252) -> Order {
        order::new_order(name, true, "item_a".to_string())  // Make item_a a string
    }

    pub fn dummy_emailed_order(name: felt252) -> Order {
        order::new_order(name, false, "item_a".to_string())  // Make item_a a string
    }

    pub fn order_fees(order: Order) -> u16 {  // Change the return type to u16
        if order.made_by_phone {
            500
        } else {
            200
        }
    }
}

#[test]
fn test_array() {
    let order1 = order_utils::dummy_phoned_order("John Doe".to_string());  // Make names strings
    let fees1 = order_utils::order_fees(order1);
    assert!(fees1 == 500, "Order fee should be 500");

    let order2 = order_utils::dummy_emailed_order("Jane Doe".to_string());  // Make names strings
    let fees2 = order_utils::order_fees(order2);
    assert!(fees2 == 200, "Order fee should be 200");
}
