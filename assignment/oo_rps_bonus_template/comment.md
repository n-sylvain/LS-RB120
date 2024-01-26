Hi Nathan, I'll be reviewing your code today!

User Experience
The game communicates well with the player. The input validation always works the way I'd expect.
Having different computer opponents that play differently is an interesting twist!
Rubocop
No Rubocop offenses. Nice work!

Source Code
The overall class structure here is very well-designed.
The inheritance structure and methods of Player generally makes sense. There are a few small details I noticed:
Computer::new_random works by randomly selecting a name, then a personality based on that name. You could instead make each class's name a part of its class definition (so that Mosscap objects always have the name 'Mosscap') and instead randomly select a class. This way, each class always holds its own name in its definition.
I see why Computer always needs to hold an opponent object, but I don't think it makes sense that Player defines this attribute, since Humans don't make use of their opponent.
RPSGame is organized nicely. The way you've ordered and named the methods makes it clear what role each plays.
The only change I'd make would be to move play to the top of the class definition - it's a little more developer-friendly to show the public interface first. You might then move play_round to the top of the private section, just under initialize.
play and play_round are extremely concise and readable thanks to your descriptive naming and extraction of helper methods - great work!
It's smart to mix Comparable into Move, even if we don't use that functionality in this program - it's easy to imagine uses for it.
There are a few places in Move where you reference @value directly instead of using the getter (<=>, to_s) - I'd just use the getter here.
Your line-by-line logic is great throughout. Things work elegantly and with good Ruby style.
Overall Thoughts
This is a great program, Nathan! There isn't much I'd change. Your thoughtful OO design means this program is readable and handles the extra "opponent strategy" functionality gracefully.

I hope this is helpful. If you have any questions, just let me know!

Thanks, Philip