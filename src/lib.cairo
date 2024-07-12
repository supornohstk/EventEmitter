#[starknet::interface]
pub trait IEventEmitter<TContractState> {
    fn deposit(ref self: TContractState);
    fn withdraw(ref self: TContractState);
    fn withdrawbatchSent(ref self: TContractState);
}

#[starknet::contract]
mod EventEmitter {
    use starknet::{ContractAddress, get_caller_address, get_contract_address, contract_address::{contract_address_const}};


    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Deposit: Deposit,
        Withdraw: Withdraw,
        WithdrawBatchSent: WithdrawBatchSent,
    }


    #[derive(Drop, starknet::Event)]
    struct Deposit {
        user: ContractAddress,
        amount: u256,
        l1TokenAddress: ContractAddress,
        l2TokenAddress: ContractAddress,
        dexAddress: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct Withdraw {
        user: ContractAddress,
        amount: u256,
        l1TokenAddress: ContractAddress,
        l2TokenAddress: ContractAddress,
        dexAddress: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct WithdrawBatchSent {
        amount: u256,
        l1TokenAddress: ContractAddress,
        dexAddress: ContractAddress,
        batchId: u256,
    }

    #[storage]
    struct Storage {
        balance: u256, 
    }

    #[abi(embed_v0)]
    impl EventEmmitterImpl of super::IEventEmitter<ContractState> {
        fn deposit(ref self: ContractState) {
            let mut balance = self.balance.read();
            balance = balance + 10;
            self.balance.write(balance);
            let dexAddress = contract_address_const::<23523>();
            self.emit(Deposit{
                user: get_caller_address(),
                amount: 10,
                l1TokenAddress: get_contract_address(),
                l2TokenAddress: get_contract_address(),
                dexAddress: dexAddress,
            });
        }

        fn withdraw(ref self: ContractState) {
            let mut balance = self.balance.read();
            balance = balance - 2;
            self.balance.write(balance);
            let dexAddress = contract_address_const::<23523>();
            self.emit(Withdraw{
                user: get_caller_address(),
                amount: 2,
                l1TokenAddress: get_contract_address(),
                l2TokenAddress: get_contract_address(),
                dexAddress: dexAddress,
            });
        }

        fn withdrawbatchSent(ref self: ContractState) {
            let mut balance = self.balance.read();
            balance = balance + 2000;
            balance = balance - 20;
            self.balance.write(balance);
            let dexAddress = contract_address_const::<23523>();
            self.emit(WithdrawBatchSent{
                amount: 2000,
                l1TokenAddress: get_contract_address(),
                dexAddress: dexAddress,
                batchId: 1,
            });
        }
    }
}
