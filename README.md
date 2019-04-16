# GCD-and-NSOperation

# GCD (Grand Central Dispatch)

GCD is the most commonly used API to manage concurrent code and execute operations asynchronously at the Unix level of the system. GCD provides and manages queues of tasks. First, let’s see what queues are.

# What are queues?
Queues are data structures that manage objects in the order of First-in, First-out (FIFO). Queues are similar to the lines at the ticket window of the movie theatre. The tickets are sold as first-come, first-serve. The people in the front of the line get to buy their tickets before the others in the line who arrived later. Queues in computer science are similar because the first object added to the queue is the first object to be removed from the queue.

# Dispatch Queues
Dispatch queues are an easy way to perform tasks asynchronously and concurrently in your application. They are queues where tasks are being submitted by your app in form of blocks (Blocks of codes). There are two varieties of dispatch queues: (1) serial queues, & (2) concurrent queues. Before talking about the differences, you need to know that tasks assigned to both queues are being executed in separate threads than the thread they were created on. In other words, you create blocks of code and submit it to dispatch queues in the main thread. But all these tasks (Blocks of codes) will run in separate threads instead of the main thread.

# Serial Queues
When you choose to create a queue as serial queue, the queue can only execute one task at a time. All tasks in the same serial queue will respect each other and execute serially. However, they don’t care about tasks in separate queues which means that you can still execute tasks concurrently by using multiple serial queues. For example, you can create two serial queues, each queue executes only one task at a time but up to two tasks could still execute concurrently.

# The advantages of using serial queues are:

1. Guaranteed serialized access to a shared resource that avoids race condition.
2. Tasks are executed in a predictable order. When you submit tasks in a serial dispatch queue, they will be executed in the same order as they are inserted.
3. You can create any number of serial queues.

# Concurrent Queues
As the name suggests, concurrent queues allows you to execute multiple tasks in parallel. The tasks (blocks of codes) starts in the order in which they are added in the queue. But their execution all occur concurrently and they don’t have to wait for each other to start. Concurrent queues guarantee that tasks start in same order but you will not know the order of execution, execution time or the number of tasks being executed at a given point.
Now that we have explained both serial and concurrent queues, it’s time to see how we can use them. By default, the system provides each application with a single serial queue and four concurrent queues. The main dispatch queue is the globally available serial queue that executes tasks on the application’s main thread. It is used to update the app UI and perform all tasks related to the update of UIViews. There is only one task to be executed at a time and this is why the UI is blocked when you run a heavy task in the main queue.

Besides the main queue, the system provides four concurrent queues. We call them Global Dispatch queues. These queues are global to the application and are differentiated only by their priority level. To use one of the global concurrent queues, you have to get a reference of your preferred queue using the function dispatch_get_global_queue which takes in the first parameter one of these values:

         DISPATCH_QUEUE_PRIORITY_HIGH
         DISPATCH_QUEUE_PRIORITY_DEFAULT
         DISPATCH_QUEUE_PRIORITY_LOW
         DISPATCH_QUEUE_PRIORITY_BACKGROUND
These queue types represent the priority of execution. The queue with HIGH has the highest priority and BACKGROUND has the lowest priority. So you can decide the queue you use based on the priority of the task. Please also note that these queues are being used by Apple’s APIs so your tasks are not the only tasks in these queues.

Lastly, you can create any number of serial or concurrent queues. In case of concurrent queues, I highly recommend to use one of the four global queues, though you can also create your own.









# Operation queues

GCD is a low-level C API that enables developers to execute tasks concurrently. Operation queues, on the other hand, are high level abstraction of the queue model, and is built on top of GCD. That means you can execute tasks concurrently just like GCD, but in an object-oriented fashion. In short, operation queues just make developers’ life even simpler.

Unlike GCD, they don’t conform to the First-In-First-Out order. Here are how operation queues are different from dispatch queues:

1. Don’t follow FIFO: in operation queues, you can set an execution priority for operations and you can add dependencies between operations which means you can define that some operations will only be executed after the completion of other operations. This is why they don’t follow First-In-First-Out.
By default, they operate concurrently: while you can’t change its type to serial queues, there is still a workaround to execute tasks in operation queues in sequence by using dependencies between operations.
2. Operation queues are instances of class NSOperationQueue and its tasks are encapsulated in instances of NSOperation.

# NSOperation 
Tasks submitted to operation queues are in the form of NSOperation instances. We discussed in GCD that tasks are submitted in block. The same can be done here but should be bundled inside NSOperation instance. You can simply think of NSOperation as a single unit of work.
NSOperation is an abstract class which can’t be used directly so you have to use NSOperation subclasses. In the iOS SDK, we are provided with two concrete subclasses of NSOperation. These classes can be used directly, but you can also subclass NSOperation and create your own class to perform the operations. The two classes that we can use directly are:

# NSBlockOperation – 
Use this class to initiate operation with one or more blocks. The operation itself can contain more than one block and the operation will be considered as finish when all blocks are executed.

# NSInvocationOperation 
Use this class to initiate an operation that consists of invoking a selector on a specified object.
So what’s the advantages of NSOperation?

First, they support dependencies through the method addDependency(op: NSOperation) in the NSOperation class. When you need to start an operation that depends on the execution of the other, you will want to use NSOperation.
NSOperation Illustration
Secondly, you can change the execution priority by setting the property queuePriority with one of these values:

          public enum NSOperationQueuePriority : Int {
              case VeryLow
              case Low
              case Normal
              case High
              case VeryHigh
          }


1. The operations with high priority will be executed first.
2. You can cancel a particular operation or all operations for any given queue. The operation can be cancelled after being added to the queue. Cancellation is done by calling method cancel() in the NSOperation class. When you cancel any operation, we have three scenarios that one of them will happen:
3. Your operation is already finished. In that case, the cancel method has no effect.
4. Your operation is already being executing. In that case, system will NOT force your operation code to stop but instead, cancelled property will be set to true.
5. Your operation is still in the queue waiting to be executed. In that case, your operation will not be executed.
6. NSOperation has 3 helpful boolean properties which are finished, cancelled, and ready. finished will be set to true once operation execution is done. cancelled is set to true once the operation has been cancelled. ready is set to true once the operation is about to be executed now.
7. Any NSOperation has an option to set completion block to be called once the task being finished. The block will be called once the property finished is set to true in NSOperation.


