// enums3.cairo
// Address all the TODOs to make the tests pass!
// Execute `starklings hint enums3` or use the `hint` watch subcommand for a hint.



use debug::PrintTrait;

#[derive(Drop, Copy)]
enum Message {
    ChangeColor((u8, u8, u8)),
    Echo(felt252),
    Move(Point),
    Quit,
}

#[derive(Drop, Copy)]
struct Point {
    x: u8,
    y: u8,
}

#[derive(Drop, Copy)]
struct State {
    color: (u8, u8, u8),
    position: Point,
    quit: bool,
}

trait StateTrait {
    fn change_color(ref self: State, new_color: (u8, u8, u8)) -> State;
    fn quit(ref self: State) -> State;
    fn echo(ref self: State, s: felt252);
    fn move_position(ref self: State, p: Point) -> State;
    fn process(ref self: State, message: Message) -> State;
}

impl StateImpl of StateTrait {
    fn change_color(ref self: State, new_color: (u8, u8, u8)) -> State {
        State {
            color: new_color,
            position: self.position,
            quit: self.quit,
        }
    }

    fn quit(ref self: State) -> State {
        State {
            color: self.color,
            position: self.position,
            quit: true,
        }
    }

    fn echo(ref self: State, s: felt252) {
        s.print();
    }

    fn move_position(ref self: State, p: Point) -> State {
        State {
            color: self.color,
            position: p,
            quit: self.quit,
        }
    }

    fn process(ref self: State, message: Message) -> State {
        match message {
            Message::ChangeColor(color) => self.change_color(color),
            Message::Quit => self.quit(),
            Message::Echo(s) => {
                self.echo(s);
                self.clone()
            }
            Message::Move(p) => self.move_position(p),
        }
    }
}

#[test]
fn test_match_message_call() {
    let mut state = State {
        quit: false,
        position: Point { x: 0, y: 0 },
        color: (0, 0, 0),
    };

    state = state.process(Message::ChangeColor((255, 0, 255)));
    state = state.process(Message::Echo("hello world".to_string()));
    state = state.process(Message::Move(Point { x: 10, y: 15 }));
    state = state.process(Message::Quit);

    assert!(state.color == (255, 0, 255), "wrong color");
    assert!(state.position.x == 10, "wrong x position");
    assert!(state.position.y == 15, "wrong y position");
    assert!(state.quit == true, "quit should be true");
}
