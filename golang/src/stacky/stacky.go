//name of package
package stacky 

// Stack struct with a field of a slice of items
type Stack struct {
	items []int
}
// Queue struct with a field of a slice of items
type Queue struct {
	items []int
}
//Push method adds to the top of the stack
func (s *Stack) Push(i int)  {
	s.items=append(s.items,i)
}
// Pop method removes from the top element in the stack and returns the removed item
func (s *Stack) Pop() int {
	removable:=s.items[len(s.items)-1]
	s.items=s.items[:len(s.items)-1]
	return removable
}
// Peek method queries what the top element of the stack is
func (s *Stack) Peek() int {
	removable:=s.items[len(s.items)-1]
	return removable
}
//IsEmpty method queries whether the stack is currently empty
func (s *Stack) IsEmpty() bool  {
	if len(s.items)==0 {
		return true
	}
	return false
}
//Enqueue method adds an item to the queue
func (q *Queue) Enqueue(i int)  {
	q.items=append(q.items, i)
}
//Dequeue method removes an item from the queue
func (q *Queue) Dequeue()  {
	q.items= q.items[1:]
}
