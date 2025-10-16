# Content

A quick run-through how I configure my PowerShell.

Should I ever need to restore, this serves as a reminder. Don't expect
too many explanations here :-)

1. Run install-modules.ps1 and follow the output.
1. Install proper fonts. We will stick to Cascadia, but we will use a variant that is
   properly designed.
   Visit [the release page for Cascadia Code](https://github.com/microsoft/cascadia-code/releases),
   and install from there.  
   Any font that is truly Unicode will do.
   (But remember: Microsoft as a whole still _won't_ into Unicode [^1]), they ignore how e.g. DevOps works.)
1. Restore the backup for the PS profile, the custom modules, and other things.
1. For oh-my-posh themes, visit [their page](https://ohmyposh.dev/). I don't use zsh on Linux, I prefer
   not to overload my shells, but PowerShell in coding and usage is already a resource and time waster,
   so this was a fast, good-looking approach I can check as done.

[^1]: Microsoft not giving a f$@#! about user requirements in terms of PS and Unicode,
      [GitHub](https://github.com/PowerShell/PowerShell/issues/7233), visited on 2025-10-15
