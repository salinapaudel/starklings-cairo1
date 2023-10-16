use array::ArrayTrait;
use option::OptionTrait;

fn create_array() -> Array<felt252> {
    let mut a = ArrayTrait::new();  // Use 'mut' to make 'a' mutable
    a.append(0);  // Initialize the first element as 0
    a.append(1);  // Add the other two elements
    a.append(2);
    a
}

// Don't change anything in the test
#[test]
fn test_array_len() {
    let mut a = create_array();
    assert(a.len() == 3, "Array length is not 3");
    assert(a.pop_front().unwrap() == 0, "First element is not 0");
}
