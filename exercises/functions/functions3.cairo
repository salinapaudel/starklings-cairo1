// functions3.cairo
// Execute `starklings hint functions3` or use the `hint` watch subcommand for a hint.

use debug::PrintTrait;

fn main() {
    call_me(42); // Call the function with a u64 argument
}

fn call_me(num: u64) {
    num.print(); // Print the u64 value
}

