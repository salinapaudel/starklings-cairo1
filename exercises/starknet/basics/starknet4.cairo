// Import necessary libraries
use starknet::ContractAddress;
use starknet::get_caller_address;

#[starknet::interface]
trait ILizInventory<TContractState> {
    fn add_stock(ref self: TContractState, product: felt252, new_stock: u32);
    fn purchase(ref self: TContractState, product: felt252, quantity: u32);
    fn get_stock(self: @TContractState, product: felt252) -> u32;
    fn get_owner(self: @TContractState) -> ContractAddress;
}

#[starknet::contract]
mod LizInventory {
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    // Define the storage struct
    #[storage]
    struct Storage {
        contract_owner: ContractAddress,
        inventory: LegacyMap<felt252, u32>,
    }

    // Constructor to initialize the contract with an owner
    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.contract_owner.write(owner);
    }

    // Add stock function
    #[external(v0)]
    fn add_stock(ref self: ContractState, product: felt252, new_stock: u32) {
        // Get the caller's address
        let caller = get_caller_address();

        // Ensure that only the owner can add stock
        assert(caller == self.get_owner(), 'Only the owner can add stock');

        // Get the current stock
        let current_stock = self.inventory.read(product);

        // Update the stock
        self.inventory.write(product, current_stock + new_stock);
    }

    // Purchase function
    #[external(v1)]
    fn purchase(ref self: ContractState, product: felt252, quantity: u32) {
        // Get the current stock
        let current_stock = self.inventory.read(product);

        // Check if there's enough stock to purchase
        assert(current_stock >= quantity, 'Not enough stock to purchase');

        // Update the stock
        self.inventory.write(product, current_stock - quantity);
    }

    // Get stock function
    #[view(v2)]
    fn get_stock(self: @ContractState, product: felt252) -> u32 {
        self.inventory.read(product)
    }

    // Get owner function
    #[view]
    fn get_owner(self: @ContractState) -> ContractAddress {
        self.contract_owner.read()
    }
}

// Test module
#[cfg(test)]
mod test {
    use starknet::ContractAddress;
    use array::ArrayTrait;
    use array::SpanTrait;
    use debug::PrintTrait;
    use traits::TryInto;
    use starknet::syscalls::deploy_syscall;
    use core::result::ResultTrait;

    use starknet::Felt252TryIntoContractAddress;
    use option::OptionTrait;
    use super::LizInventory;
    use super::ILizInventoryDispatcher;
    use super::ILizInventoryDispatcherTrait;

    #[test]
    #[available_gas(2000000000)]
    fn test_owner() {
        let owner: ContractAddress = 'Elizabeth'.try_into().unwrap();
        let dispatcher = deploy_contract();

        // Check that the contract owner is set correctly
        let contract_owner = dispatcher.get_owner();
        assert(contract_owner == owner, 'Elizabeth should be the owner');
    }

    #[test]
    #[available_gas(2000000000)]
    fn test_stock() {
        let dispatcher = deploy_contract();
        let owner = util_felt_addr('Elizabeth');

        // Call the contract as the owner
        starknet::testing::set_contract_address(owner);

        // Add stock
        dispatcher.add_stock('Nano', 10);
        let stock = dispatcher.get_stock('Nano');
        assert(stock == 10, 'Stock should be 10');

        dispatcher.add_stock('Nano', 15);
        let stock = dispatcher.get_stock('Nano');
        assert(stock == 25, 'Stock should be 25');
    }

    #[test]
    #[available_gas(2000000000)]
    fn test_stock_purchase() {
        let owner = util_felt_addr('Elizabeth');
        let dispatcher = deploy_contract();

        // Call the contract as the owner
        starknet::testing::set_contract_address(owner);

        // Add stock
        dispatcher.add_stock('Nano', 10);
        let stock = dispatcher.get_stock('Nano');
        assert(stock == 10, 'Stock should be 10');

        // Call the contract as a different address
        starknet::testing::set_caller_address(0.try_into().unwrap());

        dispatcher.purchase('Nano', 2);
        let stock = dispatcher.get_stock('Nano');
        assert(stock == 8, 'Stock should be 8');
    }

    #[test]
    #[should_panic]
    #[available_gas(2000000000)]
    fn test_add_stock_fail() {
        let dispatcher = deploy_contract();

        // Try to add stock, should panic to pass the test
        dispatcher.add_stock('Nano', 20);
    }

    #[test]
    #[should_panic]
    #[available_gas(2000000000)]
    fn test_purchase_out_of_stock() {
        let dispatcher = deploy_contract();

        // Purchase out of stock, should panic to pass the test
        dispatcher.purchase('Nano', 2);
    }

    fn util_felt_addr(addr_felt: felt252) -> ContractAddress {
        addr_felt.try_into().unwrap()
    }

    fn
