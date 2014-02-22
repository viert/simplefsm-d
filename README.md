simplefsm-d
===========

Simple finite state machine class for D language

## Usage

    import fsm, std.stdio;
    
    class MyFSM : SimpleFSM!(string) {
      
      string[string] results;
      string currentKey;
      
      HandlerResult getKey(string cargo) {
        auto newState = currentState;
        string accumulator;
        foreach(i, sym; cargo.dup) {
          switch(sym) {
            
            case '\n':
              newState = "error";
              break;
              
            case ':':
              currentKey = accumulator;
              cargo = cargo[i+1..$];
              newState = "get_value";
              HandlerResult result = { cargo, newState };
              return result;
              break;
              
            default:
              accumulator ~= sym;
              break;
          }
        }
        HandlerResult result = { "", "error" };
        return result;
      }
      
      HandlerResult getValue(string cargo) {
        auto newState = currentState;
        string accumulator;
        foreach(i, sym; cargo.dup) {
          switch(sym) {
            
            case '\n':
              results[currentKey] = accumulator;
              currentKey = "";
              cargo = cargo[i+1..$];
              newState = "get_key";
              HandlerResult result = { cargo, newState };
              return result;
              break;
              
            default:
              accumulator ~= sym;
              break;
          }
        }
        results[currentKey] = accumulator;
        HandlerResult result = { "", "finished" };
        return result;
      }
      
      this() {
        this.AddState("get_key", &getKey);
        this.AddState("get_value", &getValue);
        this.AddEndState("finished");
        this.AddEndState("error");
      }
      
    }
    
    void main() {
      auto f = new MyFSM();
      auto test_string = "Key:Value\nBlah:Minor";
      auto state = f.Execute("get_key", test_string);
      assert(state == "finished");
      assert(f.results == ["Key":"Value","Blah":"Minor"]);
      writeln(f.results);
      stdin.readln();
    }
    
### Credits

Inspired by Denis Papathanasiou's post http://denis.papathanasiou.org/2013/02/10/state-machines-in-go-golang/ presenting simple state machine for Go language
