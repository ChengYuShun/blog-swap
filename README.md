How to swap two values effectively?  Typically we use the following algorithm:

```
temp <- Num1
Num1 <- Num2
Num2 <- temp
```

But there is a famous alternative, which does not require the extra variable
`temp`:

```
Num1 <- Num1 + Num2
Num2 <- Num1 - Num2
Num1 <- Num1 - Num2
```

And its sibling:


```
# ^ for XOR
Num1 <- Num1 ^ Num2
Num2 <- Num1 ^ Num2
Num1 <- Num1 ^ Num2
```

Which one is faster?

# Assembly

Language matters.  To really research into that question, we need a serious
language, close enough to hardware.  C is a good choice, but modern compilers
always do some optimizatiion, which might convert whatever algorithm into the
optimal one.  So we use assembly.

On machine level, data are basically stored in two places - registers and
memory.  Disk is also accessible, but system calls are required, and therefore
it's not discussed here.

# Register and Register

We first look at how to swap values in two registers:

- the [`temp` algorithm](./r_temp.S): $2.76$ s
- the [plus-minus algorithm](./r_pm.S): $12.18$ s
- the [XOR algorithm](./r_xor.S): $8.12$ s

For each algorithm, the swapping is performed for $10,000,000,000$ times.

So we see that the `temp` algorithm is really faster, and XOR-ing is also
faster than adding or subtracting.

Note that there is actually another way to swap two values on an `x86_64`
system, that is the command [`xchg`](./r_xchg.S), which takes $2.73$, the same
as our `temp` algorithm.

# Register and Memory

How about swapping a register value and a memory value?

## `Temp`

For [the `temp` algorithm](./rm_temp.S), everything would be fine if it just
stays the same; it takes $0.98$ s.

## XOR

[XOR-ing](./rm_xor.S) would take $2.48$ s, which is longer.

I thought first of all loading the memory into a temporary register would
reduce the time taken, which is tested [here](./rm_xor_temp.S), but it
wouldn't; it takes $2.51$ s.

Also, note that we are sure this method is going to be slower than the `temp`
one.

```
# This is what our new XOR algorithm does.
Reg2 <- Mem
SWAP_BY_XOR Reg1 Reg2
Mem <- Reg2
```

Since we have already known that `SWAP_BY_XOR` for registers is slower than
`SWAP_BY_TEMP` for registers anyway, the algorithm here is slower than the one
replacing `SWAP_BY_XOR` with `SWAP_BY_TEMP`, which is obviously slower than the
`temp` we used for memory.

## `xchg`

The `xchg` command still works here but in two different ways.  You can put the
memory address on the left or on the right hand side, taking $8.01$ and $8.09$
seconds, respectively.

## Note

Each algorithm carries swapping for $1,000,000,000$ times now.

We won't even be using the plus-minus algorithm from now on, because the are a
lot slower than the XOR one, not to mention its overflow vulnerability.

# Memory and Memory

Since `x86` instructions generally do not accept two memory addresses, if we
want to swap two values in memory, we have to load at least one of the values
into memory.

The `temp` algorithm now becomes [a better version](./m_temp.S).  Let's loop at
the pseudo code:

```
Reg1 <- Mem1
Reg2 <- Mem2
Mem1 <- Reg2
Mem2 <- Reg1
```

We don't need to benchmark XOR and `xchg`.  Because both of them would
essentially do this:

```
Reg <- Mem1
SWAP Reg Mem2
Mem1 <- Reg
```

and as we have shown above, the `SWAP`ing step would always be slower than the
`temp` algorithm, and even if we use the `temp` swapping here, it would still
be slower than our enhanced version for memory addresses.

# Note in Practice

Seems like the `temp` algorithm is optimal, isn't it?  Actually, no.

## When to Use `xchg`

Consider the scenario, where you have all of your registers occupied, yet you
want to swap two values stored in registers, perhaps preparing for a function
call.

The `temp` algorithm would then look like this:

```
# Push Reg3 onto the stack
PUSH Reg3
Reg3 <- Reg1
Reg1 <- Reg2
Reg2 <- Reg3
# Pop Reg3 from the stack
POP Reg3
```

Now the `xchg` instruction has its place; we can swap two registers with out
using the third one - `XCHG Reg1 Reg2` - which is free from memory access, thus
obviously faster.

## When to Use XOR

If you still have all the registers occupied, but you want to swap a register
and a memory location, XOR-ing would be a reasonable choice, since it would
stays the same, while `temp` requires two extra memory access.

Let's do some benchmark now. [`temp`](./noreg_rm_temp.S): $1.91$ s.  Okay, I'm
wrong, `temp` is still the best option.

## How to Choose From the Algorithms

Use `temp`.

From a programming perspective, `temp` is easier to be understood, and it is
also reasonably fast.  If you are still not comfortable with this answer,
wanting to find the absolutely most efficient algorithm, you should trust you
compiler, they will do the work for you.

# Extra Note

All swapping here swap two quadwords, which is $8$ bytes.

You can try to compile the source code in this repository on Linux or MacOS
with [GCC](https://www.gnu.org/software/gcc/), [GNU
make](https://www.gnu.org/software/make/), and [GNU
time](https://www.gnu.org/software/time/) installed.  On MS Windows, I
personally recommend [the MSYS2 project](https://www.msys2.org/).

# See Also

[Wikipedia: XOR swap
algorithm](https://en.wikipedia.org/wiki/XOR_swap_algorithm)

# License

This article is written by Yushun Cheng, published under [Creative Commons
Attribution 4.0 International
License](https://creativecommons.org/licenses/by/4.0/).

All the codes, including the [Makefile](./Makefile), are in public domain.
