# Mod of Pokemon Yellow Legacy

Pokemon Yellow Legacy is fantastic but it could be better. I reworked the AI to not be an idiot, changed the Pokemon availability to follow their environmental typing while trying to make ecological sense, switched dragon to be physical and balanced the lategame a bit.

Pokemon availability changes:
- Encounter tables changed to follow pokemon environment typing
- Surfing tables changed to follow watertypes
- Fishing rods changed so all rods have location dependent encounter tables
- Magikarp from salesman now costs 5k instead of 500
- Mr Mime trader now wants Abra instead of Clefairy
- Celadon Mansion now has Porygon instead of Eevee
- Game corner now sells Magmar(1500), Electabuzz(2000), Mr Mime(2500), Dratini(5000),  Eevee(9999), Porygon(3000)
- Eevee as starter(but cries and animations not changed)

Move changes:
- Dragon type moves are now treated as physical attacks
- Night shade now has 75 base power and secondary lower attack effect

Learnset changes:
- Bellsprout starts with constrict and growth instead of vine whip/growth
- Bellsprout learns poisonpowder at 7, vine whip at 13
- Ekans learns poison sting at 5
- Krabby starts with bubble instead of bubble/leer
- Krabby learns tackle at 7, leer at 11, sharpen at 16
- Growlithe starts with bite and growl instead of bite/roar
- Growlithe learns lick at 7, roar at 12, agility at 42
- Arcanine now has the same learnset as Growlithe
- Psyduck/Golduck now learn fury swipes at 33(level up)

Balance changes:
- Shift setting no declares what pokemon the enemy is going to use
- Badge boosts removed completely
- Stat EXP effect halved
- Completely reworked AI routine that does not cheat.

Miscellaneous fixes:
- Pokedex pokemon area overflow fix so it no longer inverts colours

Below is the original description of the Yellow legacy hack and below that you can find the detailed AI routine changes if you want to spoil yourself or are interested in it itself.

# Pokémon Yellow Legacy

The Yellow Legacy project is the prequel to [Crystal Legacy](https://github.com/cRz-Shadows/Pokemon_Crystal_Legacy) by content creator Patrick Smith ([TheSmithPlays](https://www.youtube.com/@TheSmithPlays)), and the second project in his planned Legacy series. It is based on [the Pokémon Yellow Disassembly](https://github.com/pret/pokeyellow). The Legacy project is focused on changing the base game in a way that adds quality of life additions and better balancing with the benefit of twenty years of hindsight. The primary goal of each mod is to keep the original feeling of the game while still making meaningful improvements for the player. This means that certain idiosyncrasies of the first generation of Pokémon games will remain, as they are considered an essential aspect to the core experience.

Pokémon Yellow exists in a unique role in the Pokémon franchise – it was the first truly significant revision of existing Pokémon games, and it still exists as the only core Pokémon game to be influenced by the anime. Furthermore, Pokémon Yellow introduced greater use of color, more challenging boss fights, availability for all three starters, and Pikachu as your companion. As a project to improve this game, Yellow Legacy seeks to find balance between furthering the unique niche of anime-influence while still representing the first generation of Pokémon as a whole.

Yellow Legacy aims to give each Pokémon a special niche. Balance changes were made with the intent to keep the first generation of Pokémon feeling similar to their original incarnations, while also guaranteeing that using your favorite Pokémon will not significantly handicap your journey through Kanto. As the intent is to maintain the feeling of the Generation 1 games, Yellow Legacy will not change core aspects of the battle system such as the sleep status, critical hit chance being based off of speed, or the overpowered functionality of trapping moves such as Wrap or Fire Spin. 

While Yellow Legacy is not designed as a “Kaizo” project, Pokémon trainer fights (especially bosses) throughout the game have been made more difficult. Difficulty is used as a tool to make the game as engaging as possible to the most amount of players. It will not be difficult for the sake of being difficult, but rather, to provide you with a challenge that gives reaching the title of Champion a feeling of genuine earned satisfaction. Major trainers will have Pokémon and attacks designed to counter players attempting to easily sweep through the fight with a single super-effective Pokémon. However, players will also have more opportunities to create unique teams of stellar Pokémon to tackle each major fight. Pokémon availability has also been altered throughout the world to provide appropriately-powerful Pokémon based on your progression through the game. Finally, all 151 Pokémon will be obtainable in a single playthrough, and a small amount of post-game content has been added as well.


## Download and Play

* ### **You should use RGBDS version 0.6.1.**
* To set up the repository, see [**INSTALL.md**](INSTALL.md).


## A complete list of features can be found here:
- Full doc: 
    - [Make a Copy (Recommended)](https://docs.google.com/document/d/1JlZRhW2fcBUd7y23DB7MGfJCU95FK_yJI-QdRFdMawI/copy)
    - [Download as PDF](https://docs.google.com/document/d/1JlZRhW2fcBUd7y23DB7MGfJCU95FK_yJI-QdRFdMawI/export?format=pdf)

These videos also provide an overview of the hack and the ideology behind it:
- Release 1.0: https://youtu.be/jTH2fVqHPwc
- Prerelease: https://www.youtube.com/playlist?list=PLyv5bsGgaxonXuHoUUsv3mM7xzTwENccO


## Our Other Projects
* Pokemon Crystal Legacy: https://github.com/cRz-Shadows/Pokemon_Crystal_Legacy
* Pokemon Cursed Yellow: https://github.com/cRz-Shadows/Pokemon_Cursed_Yellow
* Pokemon Battle Simulator: https://github.com/cRz-Shadows/Pokemon_Trainer_Tournament_Simulator


## Discussion and Community
* YouTube: https://www.youtube.com/@smithplayspokemon
* Discord: https://discord.gg/Wupx8tHRVS
* Reddit: https://www.reddit.com/r/PokemonLegacy
* Twitter: https://twitter.com/TheSmithPlays
* Instagram: https://www.instagram.com/thesmithplays/


## Pret Stuff
- **All Pret Projects:** [pret.github.io](https://pret.github.io/).
- [**FAQ**](FAQ.md)
- [**Wiki**][wiki] (includes [tutorials][tutorials])
- **Discord:** [pret][discord]
- **IRC:** [libera#pret][irc]


## Credits For Yellow Legacy:

### Creators:
- TheSmithPlays - Developer
- cRz Shadows - Devoloper
- Weebra - Video Editor


### Playtesters:
- Aerogod
- Disq
- Karlos
- ZuperZACH
- Regi
- Isona
- Obelisk
- JanitorOPplznerf
- Sable
- Alakadoof
- ReaderDragon
- Rwne
- Talos
- Tiberius
- SoulXCross
- Mogul


### Sprite Artists:
- Backsprites - Anyone is welcome to use any of our backsprites so long as you **credit the artists** listed here
    - ZuperZACH
    - Isona
    - Karlos
    - Reader Dragon
    - Alakadoof
- Pokemon overworld sprites - Anyone is welcome to use any of our overworld sprites so long as you **credit the artists** listed here
    - Isona
    - Alakadoof
    - Karlos
- Pokemon party sprites
    - Chamber
    - Soloo993
    - Blue Emerald
    - Lake
    - Neslug
    - Pikachu25
- Green sprite
    - Madame Frog/Hatun
    - Ghost-MissingNo
- Porygon Front Sprite - Zeta_Null
- Nurse Joy Battle Sprite - ZuperZACH
- Officer Jenny Battle Sprite - Karlos
- Misty overworld sprite - Isona
- (Removed) Leaf sprite - Longlostsoul


### Where you can find all Pret Tutorials:
* https://github.com/pret/pokeyellow/wiki/Tutorials
* https://github.com/pret/pokered/wiki/Tutorials


### Code Credits:
- Rangi42:
    - [Talk to Surf water, Cut trees, and Strength boulders](https://github.com/Rangi42/redstarbluestar/commit/050aae8aa99c33df803f945b8138f9a94c838908)
    - [Item Descriptions (Tutorial written by YakiNeen)](https://github.com/pret/pokered/wiki/Item-Descriptions)
- PlagueVonKarma:
    - KEP’s AI is based on Vortyne’s PureRGB AI, with elements from Jojobear13’s Shinred AI
        - https://github.com/PlagueVonKarma/kep-hack/blob/0af5bd126bd1d1b69bfd9b7fe3da20e1b14f094c/engine/battle/trainer_ai.asm
        - https://github.com/PlagueVonKarma/kep-hack/commit/0af5bd126bd1d1b69bfd9b7fe3da20e1b14f094c
        - https://github.com/PlagueVonKarma/kep-hack/commit/e6763371e4fcb26da70709fe0566ab4a8d1d2083
        - https://github.com/PlagueVonKarma/kep-hack/commit/c8f27d8bce0a0708d347f510694be4fba8158c65
    - [Already Caught Icon](https://github.com/PlagueVonKarma/kep-hack/commit/00efe3c6b461773a20b424fbf548cb38c880c9ac)
    - [Move Relearner & Move Deleter](https://github.com/pret/pokered/wiki/Adding-a-Move-Relearner-&-Move-Deleter)
    - [Safari zone rock buff](https://github.com/PlagueVonKarma/kep-hack/blob/7cd95d15616fb04b2a386b9f4df5e190dbda9a0c/engine/battle/core.asm#L4)
    - [DV / Stat Exp display in stat menu](https://github.com/PlagueVonKarma/kep-hack/commit/98110eddc82ff056a0c8420dc96fe5d9bbd9cb79)
    - [Overworld Strength](https://github.com/PlagueVonKarma/kep-hack/blob/dd5f64ad0644684bf35228362c6edebf37fa51db/home/overworld_text.asm#L4)
    - [Faster Spinners](https://github.com/PlagueVonKarma/kep-hack/commit/7c5c2a3047dd74b9ed014053172e0222b49d486b)
    - [Shorter Exp All Message](https://github.com/pret/pokered/wiki/Experience-System-&-Exp.-All-Enhancements-(Single-message,-etc))
- Jojobear13:
    - [Box full reminder ](https://github.com/jojobear13/shinpokered/commit/7223a046997168913e67444b509ec15462bc7ec1)
    - [Player animation is faster when running](https://github.com/jojobear13/shinpokered/commit/34b1776a54c7617f749e8ca2757721d58a59c150)
    - [Pokemon can now learn more than 1 move per level](https://github.com/jojobear13/shinpokered/commit/d3357ca3b68af11a66e4f60459cd354f65e99e39)
    - [TM names display on pick up](https://github.com/jojobear13/shinpokered/commit/34c4a36a581769a59e45449fd2bdcad31ee54a99)
- YakiNeen:
    - [Item Descriptions (Code by Rangi42)](https://github.com/pret/pokered/wiki/Item-Descriptions)
    - [Remove Redundant TrainerNamePointers](https://github.com/pret/pokered/wiki/Remove-Redundant-TrainerNamePointers)
    - [Remove Redundant Card Key Function](https://github.com/pret/pokered/wiki/Remove-Redundant-Card-Key-Function)
    - [Remove Some Japanese Text Grammar Functions](https://github.com/pret/pokered/wiki/Remove-Some-Japanese-Text-Grammar-Functions)
    - [Remove Unused Tile in gfx overworld fishing_rod.png](https://github.com/pret/pokered/wiki/Remove-Unused-Tile-in-gfx-overworld-fishing_rod.png)
    - [Remove Dakutens and Handakutens feature](https://github.com/pret/pokered/wiki/Remove-Dakutens-and-Handakutens-feature)
    - [Remove Japanese Opening Quote and put BOLD P in gfx font font_battle_extra.png](https://github.com/pret/pokered/wiki/Remove-Japanese-Opening-Quote-and-put-BOLD-P-in-gfx-font-font_battle_extra.png)
    - [Remove Blank Leader Names](https://github.com/pret/pokered/wiki/Remove-Blank-Leader-Names)
    - [Out of Bounds don't Crash the Game](https://github.com/pret/pokered/wiki/Out-of-Bounds-don't-Crash-the-Game)
    - [Fix No Mon Scenarios Softlock](https://github.com/pret/pokered/wiki/Fix-No-Mon-Scenarios-Softlock)
    - [Collision check when Jumping a Ledge](https://github.com/pret/pokered/wiki/Collision-check-when-Jumping-a-Ledge)
- Vortyne:
    - [Multiple-level-up learnset skipping bug fix](https://github.com/Vortyne/pureRGB/commit/9c38ff4a1afb8c0773202b37c8b9068b4b9f4354)
    - [Move overworld tile anim code out of home bank](https://github.com/Vortyne/pureRGB/commit/09c037f5df39cd99fe4e13b4d5fee8ed86206e7b)
- Pgattic:
    - [Running Shoes (This required some extra work for yellow if you want to implement)](https://github.com/pret/pokered/wiki/Running-Shoes)
    - [Remove Artificial Save Delay](https://github.com/pret/pokered/wiki/Remove-Artificial-Save-Delay)
- Xillicis:
    - [Remove 25% chance for enemy stat down moves to miss](https://github.com/pret/pokered/wiki/Remove-25%25-chance-for-enemy-stat-down-moves-to-miss)
    - [Implement move priority system](https://github.com/pret/pokered/wiki/Implement-move-priority-system)
- TwitchPlaysPokemon - [Trainer pokemon nickname](https://github.com/twitchplayspokemon/tppcrystal251pub/blob/public/main.asm)
- Dannye - [Add All Unique Party Menu Sprite Icons](https://github.com/pret/pokered/wiki/Add-All-Unique-Party-Menu-Sprite-Icons)
- SoupPotato/Dannye - [Functioning EXP bar in battle](https://github.com/AhabsStudios/pokekaizen/commit/0332a4d1ca74b4993b2f4bc8d926bac971a0751d)
- Voloved - [Add Item Sorting In Bag](https://github.com/pret/pokered/wiki/Add-Item-Sorting-In-Bag)
- Veganlies2me - [Adding Gender Selection (original tutorial done by Mateo)](https://github.com/pret/pokered/wiki/Adding-Gender-Selection-(original-tutorial-done-by-Mateo))
- etdv-thevoid - [(Removed) Fourth palette for party icons](https://github.com/etdv-thevoid/Pokemon_Yellow_Legacy/tree/mon-icon-pal-fix)
- SatoMew (presumably more people worked on these but satomew is the only page author) - [Bugs and Glitches](https://github.com/pret/pokered/wiki/%5BARCHIVED%5D-Bugs-and-Glitches)
- rjd1922 - [Suggested corrections](https://github.com/cRz-Shadows/Pokemon_Yellow_Legacy/commit/8c927a551da31c750b81fa1baad1c5b376128331)


### Other Credits:
- People that generally helped out with advice or otherwise
    - Idain
    - Nayru62
    - JaaShooUhh
    - Fortello - [The Potential Yellow Legacy - Google Docs](https://docs.google.com/document/d/179pOjVbPf6k09ON6g0s75xE_qRNET9CIuHWa-aSwQlA/edit#heading=h.fd77qy88i9zy)


### Massive thank you to these hacks in particular:
- [Kanto Expansion Pak](https://github.com/PlagueVonKarma/kep-hack)
- [Shinred](https://github.com/jojobear13/shinpokered)
- [RedStar BlueStar](https://github.com/Rangi42/redstarbluestar)
- [PureRGB](https://github.com/Vortyne/pureRGB)


[wiki]: https://github.com/pret/pokeyellow/wiki
[tutorials]: https://github.com/pret/pokeyellow/wiki/Tutorials
[discord]: https://discord.gg/d5dubZ3
[irc]: https://web.libera.chat/?#pret
[ci]: https://github.com/pret/pokeyellow/actions
[ci-badge]: https://github.com/pret/pokecrystal/actions/workflows/main.yml/badge.svg



# AI changes:
- AI that does not:
    -Cheat upon switch out or switch in
    -Cheat with knowing the exact damage a move will do
    -Use moves with no effect
    -Try to hit flying/digging opponents
    -Use moves the player pokemon is immune to for any reason
    -Buff/debuff if already at full stack
    -Use substitute if too low hp
    -Use explosion moves if player pokemon is frozen
    -Use status moves if the player pokemon already has a relevant status, confusion,
- AI that:
    -Tries to knock out immediately if possible
    -Has a knockout prioritization routine that takes into account accuracy, quick attack, swift, hp drain, charge, etc.
    -Uses spore if it has it
    -Buffs speed if slower
    -Paralyzes opponent if slower
    -Uses dream eater if player pokemon is asleep
    -Has an explosion prioritization routine scaling with hp, speed and whether it knocks out the player pokemon or not
    -Currently set to use Bide as it's opener to make Brock easier as a trapping Onix is insane in the early game.
    -Tries to use trapping moves if faster
    -Has a status move prioritization routine that takes into account speed, status move effect and AI pokemon hp
    -Has a buff/debuff routine routine that takes into account speed, status move effect and AI pokemon hp
    -Knows which of its moves does most damage to the player pokemon, accounts for charge, multihit, recharge moves
    -Does not like to use lower damaging moves unless otherwise relevant
    -Does not like to use Counter below 50% hp
    -Does not like to use Bide below 100% hp
- Possible issues/improvements:
    -Does not differentiate if a move is guaranteed to knock out or a range
    -Does not have a specific debuff routine, instead this is together with the buff routine
    -Is not forced to use quick attack if slower and low on hp
    -Does not prioritize moves with side effects, just looks at the damage they do
    -There is an edge case where the AI predicts player pokemon switch out in case it had max debuff applied but as it is so rare it is not addressed.
    -There is an edge case with quick attack being the best damaging move and not being chosen that is not encountered in the game and thus not addressed.
- It consists of six AI ranking routines:
    -Idiot routine, that stops the AI from using moves that do nothing
    -Damage routine, that tells the AI not to like using moves that do less damage than it's best move and KO if it can
    -Buff routine, that gives different priorities to buff and debuff moves depending on the situation
    -Explosion routine, that gives different priorities to explosion moves depending on the situation
    -Status routine, that gives different priorities to status/heal only moves depending on the situation
    -Trap routine, that tells the AI to use trapping moves if it's faster

The six routines work alongside each other to create the move priorities and thus it is recommended to run with all of them on for most trainers. They can be mixed and matched, nothing will break, but the end results might be suboptimal. So you can have trainers that know not to use worse damaging moves than their main one but still be stupid enough to use buffs when they are at 1% hp, for example.

The exception to this is the idiot routine, 1. It has to be on at all times, for all trainers. Otherwise none of the other routines will make sense. If you want an early game trainer class with random but not idiotic decisions, give them just the idiot routine and nothing else. They will then randomly pick amongst any move that does something.
