use option::OptionTrait;
use debug::PrintTrait;

#[test]
fn test_options() {
    let target = 'starklings';
    let optional_some = Option::Some(target);
    let optional_none: Option<felt252> = Option::None(());
    simple_option(optional_some);
    simple_option(optional_none);
}

fn simple_option(optional_target: Option<felt252>) {
    if optional_target.is_some() {
        assert(optional_target.unwrap() == 'starklings', 'err1');
    } else {
        ('option is empty !').print();
    }
}
