package main
import (
	"fmt"
	stacks "github.com/fortinet_alibaba/yagosys/stacky"
)

func main() {
	//myStack is a variable of an empty stack
	myStack := stacks.Stack{}
	//the push method adds to the empty stack
	myStack.Push(10)
	myStack.Push(20)
	myStack.Push(30)

	//prints out the current state of myStack
	fmt.Println(myStack) 
	//views the top of the stack
	fmt.Println(myStack.Peek()) 
	// removes an item from the stack
	fmt.Println(myStack.Pop())
	//views the new top of the stack
	fmt.Println(myStack.Peek())
	//prints out the current state of myStack
	fmt.Println(myStack)
	//checks if the stack is empty
	fmt.Println(myStack.IsEmpty())

	//myQueue is a variable of an empty queue
	myQueue := stacks.Queue{}
	//enqueue method adds to the queue
	myQueue.Enqueue(12)
	myQueue.Enqueue(20)
	myQueue.Enqueue(50)
	
	//prints out the current state of myQueue
	fmt.Println(myQueue) 
	// removes an item from the queue
	myQueue.Dequeue()
	//prints out the new state of myStack
	fmt.Println(myQueue)
}
