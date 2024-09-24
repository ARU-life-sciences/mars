# Max's restricted shell (mars)

`sshx` (https://sshx.io/) is a secure, web based terminal sharing software. It's very cool. However, when sharing with students, we want to make sure that our personal computer is not compromised. We can also simplify the shell massively to focus only on commands which we want to teach.

It is designed to be used on a Mac - no guarantees for cross compatibility.

# Run

I currently run with:

```bash
bash mars.bash -b $(which bash)
```

As by default Mac's have an ancient BASH version, which I updated with brew.
