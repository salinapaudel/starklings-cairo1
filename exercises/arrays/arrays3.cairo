// arrays3.cairo
// Make me compile and pass the test!
// Execute `starklings hint arrays3` or use the `hint` watch subcommand for a hint.



use array::ArrayTrait;

fn create_array() -> Array<felt252> {
    let mut a = ArrayTrait::new(); // Use 'mut' to make 'a' mutable
    a.append(0);
    a.append(1);
    a.append(2);
    a.pop_front().unwrap();
    a
}

#[test]
fn test_arrays3() {
    let mut a = create_array();
    let result = a.at_mut(2); // Use 'at_mut' to access and modify the element at index 2

    // Assert that the element at index 2 is equal to the expected value
    assert(*result == 2, "Element at index 2 is not 2");
}

