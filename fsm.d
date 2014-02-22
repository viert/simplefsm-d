module fsm;

template SimpleFSM(CargoType) {
	class SimpleFSM {

		string currentState;
		struct HandlerResult {
			CargoType 	cargo;
			string 		newState;
		};
		alias HandlerResult delegate(CargoType) Handler;

		Handler[string] handlers;
		bool[string] endStates;

		void AddState(string state, Handler handler) {
			this.handlers[state] = handler;
		}

		void AddEndState(string state) {
			this.endStates[state] = true;
		}

		final string Execute(string startState, CargoType cargo) {
			currentState = startState;
			while (!(currentState in this.endStates)) {

				auto handler = currentState in this.handlers;
				if (!handler) 
					return "no_handler_found_error";

				auto hresult = (*handler)(cargo);
				currentState = hresult.newState;
				cargo = hresult.cargo;
			}
			return currentState;
		}
	}
}

