#[derive(Copy, Drop)]
struct ColorStruct {
    red: felt256,
    green: felt256,
    blue: felt256,
}

#[test]
fn classic_c_structs() {
    let green = ColorStruct {
        red: 0,
        green: 255,
        blue: 0,
    };

    assert(green.red == 0, "Red value should be 0");
    assert(green.green == 255, "Green value should be 255");
    assert(green.blue == 0, "Blue value should be 0");
}
