/* ----------------------- Inventory & Player Stat Section ---------------------------
13519146 / Fadel Ananda Dotty
*/
:- dynamic(inventory/6).
:- dynamic(inventoryP/4).
:- dynamic(currentWeapon/1).
:- dynamic(currentArmor/1).
:- dynamic(currentMisc/1).

/*inventory(ItemID, class, category, name, attack, def)*/
% --------- Inventory Management ---------
addItem(ItemID) :-
    (
    findall(ItemName, inventory(_,_,_,ItemName,_,_), List),
    length(List, Length),
    findall(PotionName, inventoryP(_,PotionName,_,_), ListP),
    length(ListP, LengthP),
    Res is Length + LengthP,
    Res >= 100,
    write('\33\[31m\33\[1mInventory Is Full\33\[m'), nl,
    !;

    /*bisa ga ya kira2*/
    ItemID > 15, ItemID =< 23,
    potion(ItemID, PotionName, PlusHP, PlusMana),
    asserta(inventoryP(ItemID, PotionName, PlusHP, PlusMana)),!;

    ItemID > 23, ItemID =< 100,
    effectPotion(ItemID, PotionName, EffectID, EffectModifier),
    asserta(inventoryP(ItemID, PotionName, EffectID, EffectModifier)),!;

    ItemID =< 15,
    item(ItemID, Class, Category, ItemName, Attack, Def),
    asserta(inventory(ItemID, Class, Category, ItemName, Attack, Def)),!;

    ItemID > 103,
    item(ItemID, Class, Category, ItemName, Attack, Def),
    asserta(inventory(ItemID, Class, Category, ItemName, Attack, Def)),!;

    ItemID > 100, ItemID < 104,
    item(ItemID, Class, Category, ItemName, Attack, Def),
    write('\33\[33m\33\[1mLegendary granted\33\[m\n'),
    asserta(inventory(ItemID, Class, Category, ItemName, Attack, Def)),!
    ), !.


delItem(ItemID) :-
    ItemID>15, ItemID =< 100,
    (
        retract(inventoryP(ItemID,ItemN,_,_)),
        format('\33\[33m\33\[1m%s\33\[37m telah dihapus.\33\[m\n',[ItemN]), !;

        \+inventoryP(ItemID,_,_,_),
        write('There is no specified potion to delete\n'), !
    ), !;
    ItemID > 103, (
        retract(inventory(ItemID,_,_,ItemN,_,_)),
        format('\33\[33m\33\[1m%s\33\[37m telah dihapus.\33\[m\n',[ItemN]), !;

        \+inventory(ItemID,_,_,_,_,_),
        write('There is no specified item to delete\n'), !
    ), !;

    ItemID > 100, ItemID < 104, (
        retract(inventory(ItemID,_,_,ItemN,_,_)),
        format('\33\[31m\33\[1m%s telah dihapus.\33\[m\n',[ItemN]), !;

        \+inventory(ItemID,_,_,_,_,_),
        write('There is no specified item to delete\n'), !
    ), !;

    ItemID=<15,
    (
        retract(inventory(ItemID,_,_,ItemN,_,_)),
        format('\33\[33m\33\[1m%s\33\[37m telah dihapus.\33\[m\n',[ItemN]), !;

        \+inventory(ItemID,_,_,_,_,_),
        write('There is no specified item to delete\n'), !
    ), !.


% --- Equip and using potion ----
equip(ItemID) :-
    currentWeapon(A),
    (ItemID =< 9, ItemID > 0, !; ItemID > 100, ItemID < 107, !),
    statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold),
    inventory(ItemID,Tipe,_,Name,WAtk,_),
    inventory(A,_,_,OldName,OldAtk,_),
    (
        retract(currentWeapon(A)),
        asserta(currentWeapon(ItemID)),
        NewAtk is Atk - OldAtk + WAtk,
        retract(statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold)),
        asserta(statPlayer(Tipe, Nama, HP, Mana, NewAtk, Def, Lvl, XP, Gold)),
        format('\33\[33m\33\[1m%s\33\[m dilepas,\n',[OldName]),
        format('\33\[33m\33\[1m%s\33\[m telah berhasil diequip!\n\n',[Name]),!;

        !
    );

    currentArmor(B),
    (ItemID > 9, ItemID < 13, !; ItemID > 106, ItemID < 110, !),
    statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold),
    inventory(ItemID, Tipe, _, Name, _,ADef),
    inventory(B,_,_,OldName,_,OldDef),
    (
        retract(currentArmor(B)),
        asserta(currentArmor(ItemID)),
        NewDef is Def - OldDef + ADef,
        retract(statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold)),
        asserta(statPlayer(Tipe, Nama, HP, Mana, Atk, NewDef, Lvl, XP, Gold)),
        format('\33\[33m\33\[1m%s\33\[m dilepas,\n',[OldName]),
        format('\33\[33m\33\[1m%s\33\[m telah berhasil diequip!\n\n',[Name]),!;

        !
    );

    currentMisc(C),
    (ItemID > 12, ItemID =< 15, !; ItemID > 109, ItemID < 113, !),
    statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold),
    inventory(ItemID, Tipe, _, Name, WAtk, ADef),
    inventory(C,_,_,OldName,OldAtk,OldDef),
    (
        retract(currentMisc(C)),
        asserta(currentMisc(ItemID)),
        NewAtk is Atk - OldAtk + WAtk,
        NewDef is Def - OldDef + ADef,
        retract(statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold)),
        asserta(statPlayer(Tipe, Nama, HP, Mana, NewAtk, NewDef, Lvl, XP, Gold)),
        format('\33\[33m\33\[1m%s\33\[m dilepas,\n',[OldName]),
        format('\33\[33m\33\[1m%s\33\[m telah berhasil diequip!\n\n',[Name]), !;

        !
    );




    % Equip new item
    (ItemID =< 9, ItemID > 0, !; ItemID > 100, ItemID < 107, !),
    statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold),
    inventory(ItemID,Tipe,_,Name,WAtk,_),
    (
        asserta(currentWeapon(ItemID)),
        NewAtk is WAtk + Atk,
        retract(statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold)),
        asserta(statPlayer(Tipe, Nama, HP, Mana, NewAtk, Def, Lvl, XP, Gold)),
        format('\33\[33m\33\[1m%s\33\[m telah berhasil diequip!\n\n',[Name]),!;

        !
    );




    (ItemID > 9, ItemID < 13, !; ItemID > 106, ItemID < 110, !),
    statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold),
    inventory(ItemID, Tipe, _, Name, _, ADef),
    (
        asserta(currentArmor(ItemID)),
        NewDef is ADef+Def,
        retract(statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold)),
        asserta(statPlayer(Tipe, Nama, HP, Mana, Atk, NewDef, Lvl, XP, Gold)),
        format('\33\[33m\33\[1m%s\33\[m telah berhasil diequip!\n\n',[Name]),!;

        !
    );

    (ItemID > 12, ItemID =< 15, !; ItemID > 109, ItemID < 113, !),
    statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold),
    inventory(ItemID, Tipe, _, Name, WAtk, ADef),
    (
        asserta(currentMisc(ItemID)),
        NewAtk is WAtk+Atk,
        NewDef is ADef+Def,
        retract(statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold)),
        asserta(statPlayer(Tipe, Nama, HP, Mana, NewAtk, NewDef, Lvl, XP, Gold)),
        format('\33\[33m\33\[1m%s\33\[m telah berhasil diequip!\n\n',[Name]), !;

        !
    );

    write('Tidak sesuai kelas.\n\n').


usePotion(PID) :-
    inventoryP(PID, Name, PlusHP, PlusMana),
    PID < 24,
    statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold),
    class(_,Tipe, MaxHP, MaxMP,_,_),
    RestoredHP is HP+PlusHP,
    RestoredMana is Mana+PlusMana,
    (
        PID > 15, PID < 20,
        RestoredHP > MaxHP, NewHP is MaxHP, Delta is NewHP - HP, NewMana is Mana,
        format('\33\[37m\33\[1mHealth  \33\[31m\33\[2m%d \33\[m→ \33\[33m\33\[1m%d \33\[m         \33\[32m\33\[1m↑\33\[m \33\[33m\33\[1m%d\33\[m\n',[HP,MaxHP,Delta]), !;

        PID > 15, PID < 20,
        NewHP is RestoredHP, Delta is RestoredHP, NewMana is Mana,
        format('\33\[37m\33\[1mHealth  \33\[31m\33\[2m%d \33\[m→ \33\[33m\33\[1m%d \33\[m         \33\[32m\33\[1m↑\33\[m \33\[33m\33\[1m%d\33\[m\n',[HP,RestoredHP,Delta]), !;

        PID > 19, PID < 24,
        RestoredMana > MaxMP, NewMana is MaxMP, Delta is NewMana - Mana, NewHP is HP,
        format('\33\[37m\33\[1mMana  \33\[36m\33\[2m%d \33\[m→ \33\[33m\33\[1m%d \33\[m         \33\[32m\33\[1m↑\33\[m \33\[33m\33\[1m%d\33\[m\n',[Mana,MaxMP,Delta]), !;

        PID > 19, PID < 24,
        NewMana is RestoredMana, Delta is RestoredMana, NewHP is HP,
        format('\33\[37m\33\[1mMana  \33\[36m\33\[2m%d \33\[m→ \33\[33m\33\[1m%d \33\[m         \33\[32m\33\[1m↑\33\[m \33\[33m\33\[1m%d\33\[m\n',[Mana,RestoredMana,Delta]), !
    ),
    retract(statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold)),
    asserta(statPlayer(Tipe, Nama, NewHP, NewMana, Atk, Def, Lvl, XP, Gold)),
    retract(inventoryP(PID, Name, PlusHP, PlusMana)),
    format('\33\[33m\33\[1m%s\33\[m telah diminum\n',[Name]), !;

    inventoryP(PID, Name, EffectID, EffectModifier),
    PID > 23, PID =< 100,
    statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold),
    (
        EffectID is 3, NewAtk is Atk + EffectModifier, NewDef is Def, Delta is EffectModifier,
        format('\33\[37m\33\[1mAttack  \33\[m\33\[2m%d\33\[m → \33\[33m\33\[1m%d\33\[m         \33\[32m\33\[1m↑\33\[m \33\[33m\33\[1m%d\33\[m\n',[Atk,NewAtk,EffectModifier]),
        write('\33\[33m\33\[1mAttack '), !;

        EffectID is 4, NewDef is Def + EffectModifier, NewAtk is Atk, Delta is EffectModifier,
        format('\33\[37m\33\[1mDefense  \33\[m\33\[2m%d\33\[m → \33\[33m\33\[1m%d\33\[m         \33\[32m\33\[1m↑\33\[m \33\[33m\33\[1m%d\33\[m\n',[Def,NewDef,EffectModifier]),
        write('\33\[33m\33\[1mDefense '), !;

        EffectID is 5, hitChance(OldAcc), addAccuracy(EffectModifier), hitChance(NewAcc), NewAtk is Atk, NewDef is Def, Delta is NewAcc - OldAcc,
        format('\33\[37m\33\[1mAccuracy  \33\[m\33\[2m%d %s \33\[m→ \33\[33m\33\[1m%d %s \33\[m         \33\[32m\33\[1m↑\33\[m \33\[33m\33\[1m%d\33\[m\n',[OldAcc,'%',NewAcc,'%',Delta]),
        write('\33\[33m\33\[1mAccuracy '), !;

        EffectID is 6, critChance(OldCrit), addCrit(EffectModifier), critChance(NewCrit), NewAtk is Atk, NewDef is Def, Delta is NewCrit - OldCrit,
        format('\33\[37m\33\[1mCritical  \33\[m\33\[2m%d %s \33\[m→ \33\[33m\33\[1m%d %s \33\[m         \33\[32m\33\[1m↑\33\[m \33\[33m\33\[1m%d\33\[m\n',[OldCrit,'%',NewCrit,'%',Delta]),
        write('\33\[33m\33\[1mCritical '), !;

        EffectID is 7, dodgeChance(OldDodge), addDodge(EffectModifier), dodgeChance(NewDodge), NewAtk is Atk, NewDef is Def, Delta is NewDodge - OldDodge,
        format('\33\[37m\33\[1mDodge  \33\[m\33\[2m%d %s \33\[m→ \33\[33m\33\[1m%d %s \33\[m         \33\[32m\33\[1m↑\33\[m \33\[33m\33\[1m%d\33\[m\n',[OldDodge,'%',NewDodge,'%',Delta]),
        write('\33\[33m\33\[1mDodge '), !
    ),
    format('bertambah sebanyak %d!\33\[m\n',[Delta]),
    retract(statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold)),
    asserta(statPlayer(Tipe, Nama, HP, Mana, NewAtk, NewDef, Lvl, XP, Gold)),
    retract(inventoryP(PID, Name, EffectID, EffectModifier)),
    !;
    write('Potion tidak ditemukan\n'), !.


addAccuracy(EffectModifier) :-
    hitChance(LastAcc),
    (
        NewAcc is LastAcc + EffectModifier,
        NewAcc =< 100, !;

        NewAcc is 100, !
    ),
    retract(hitChance(LastAcc)),
    asserta(hitChance(NewAcc)), !.

addCrit(EffectModifier) :-
    critChance(LastCrit),
    (
        NewCrit is LastCrit + EffectModifier,
        NewCrit =< 100, !;

        NewCrit is 100, !
    ),
    retract(critChance(LastCrit)),
    asserta(critChance(NewCrit)), !.

addDodge(EffectModifier) :-
    dodgeChance(LastDodge),
    (
        NewDodge is LastDodge + EffectModifier,
        NewDodge =< 100, !;

        NewDodge is 100, !
    ),
    retract(dodgeChance(LastDodge)),
    asserta(dodgeChance(NewDodge)), !.

% -------------- Show Inventory --------------
listing([],[],[],[],_).
listing(ListID, List1, List2, List3, Ctr) :-
    [I1|I2]=ListID,
    [W1|W2]=List1,
    [X1|X2]=List2,
    [Y1|Y2]=List3,
    % format('┃ ID     │ %26d  ┃',[I1]), nl,
    % format('┃ Name   │ \33\[33m\33\[1m%26s\33\[m  ┃',[W1]), nl,
    % format('┃ Attack │ %26d  ┃',[X1]), nl,
    % format('┃ Def    │ %26d  ┃',[Y1]), nl,
    (
        I1 > 100, I1 < 104,
        format('\33\[37m\33\[1m┃ %3d │ %3d │ \33\[33m\33\[1m%-24s\33\[m \33\[37m\33\[1m│ %3d │ %3d ┃',[Ctr,I1,W1,X1,Y1]), nl, !;

        format('\33\[37m\33\[1m┃ %3d │ %3d │ \33\[37m\33\[1m%-24s\33\[m \33\[37m\33\[1m│ %3d │ %3d ┃',[Ctr,I1,W1,X1,Y1]), nl, !
    ),
    % write('┠────────┴────────────────────────────┨'),nl,
    Nctr is Ctr + 1,
    listing(I2, W2, X2, Y2, Nctr).

listItem :-
    inventory(_,_,_,_,_,_),
    findall(ItemID, inventory(ItemID,_,_,_,_,_), IDs),
    findall(ItemName, inventory(_,_,_,ItemName,_,_), Names),
    findall(Attack, inventory(_,_,_,_,Attack,_), Attacks),
    findall(Def, inventory(_,_,_,_,_,Def), Defs),
    write('\33\[37m\33\[1m'), flush_output,
    write('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓'), nl,
    write('┃                      Weapon                      ┃'), nl,
    write('┠─────┬─────┬──────────────────────────┬─────┬─────┨'), nl,
    write('┃ No  │ ID  │ Nama                     │ Atk │ Def ┃'), nl,
    write('┠─────┼─────┼──────────────────────────┼─────┼─────┨'), nl,
    listing(IDs, Names, Attacks, Defs, 1),
    write('\33\[37m\33\[1m'), flush_output,
    write('┗━━━━━┷━━━━━┷━━━━━━━━━━━━━━━━━━━━━━━━━━┷━━━━━┷━━━━━┛'), nl,
    write('\33\[m'), flush_output, !;
    write('\33\[37m\33\[1mKamu tidak memiliki item\33\[m\n'), !.

listingPotion([],[],[],[],_).
listingPotion(ListID, List1, List2, List3, Ctr):-
    [I1|I2]=ListID,
    [A1|A2]=List1,
    [B1|B2]=List2,
    [C1|C2]=List3,
    (
        I1 > 15, I1 < 20,
        format('\33\[37m\33\[1m┃ %3d │ %2d │ \33\[31m\33\[1m%-25s\33\[m \33\[37m\33\[1m│ \33\[31m\33\[1m%3d\33\[m \33\[37m\33\[1m│ \33\[31m\33\[1m%3d\33\[m \33\[37m\33\[1m┃\n',[Ctr,I1,A1,1,C1]), !;

        I1 > 19, I1 < 24,
        format('\33\[37m\33\[1m┃ %3d │ %2d │ \33\[36m\33\[1m%-25s\33\[m \33\[37m\33\[1m│ \33\[36m\33\[1m%3d\33\[m \33\[37m\33\[1m│ \33\[36m\33\[1m%3d\33\[m \33\[37m\33\[1m┃\n',[Ctr,I1,A1,2,C1]), !;

        format('\33\[37m\33\[1m┃ %3d │ %2d │ \33\[33m\33\[1m%-25s\33\[m \33\[37m\33\[1m│ \33\[33m\33\[1m%3d\33\[m \33\[37m\33\[1m│ \33\[33m\33\[1m%3d\33\[m \33\[37m\33\[1m┃\n',[Ctr,I1,A1,B1,C1]), !
    ),
    % format('┃ ID            │ %19d  ┃',[I1]), nl,
    % format('┃ Name          │ %19s  ┃',[A1]), nl,
    % format('┃ HP Restored   │ %19d  ┃',[B1]), nl,
    % format('┃ Mana Restored │ %19d  ┃',[C1]), nl,
    % write('┃                                      ┃'),nl,
    Nctr is Ctr + 1,
    listingPotion(I2, A2, B2, C2, Nctr).

listPotion :-
    inventoryP(_,_,_,_),
    findall(PotionID, inventoryP(PotionID,_,_,_), PIDs),
    findall(PotionName, inventoryP(_,PotionName,_,_), PNames),
    findall(PlusHP, inventoryP(_,_,PlusHP,_), HPs),
    findall(PlusMana, inventoryP(_,_,_,PlusMana), ManaS),
    write('\33\[37m\33\[1m'), flush_output,
    write('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓'), nl,
    write('┃                      Potion                      ┃'), nl,
    write('┠─────┬────┬───────────────────────────┬─────┬─────┨'), nl,
    write('┃ No  │ ID │ Nama                      │ EID │ Mod ┃'), nl,
    write('┠─────┼────┼───────────────────────────┼─────┼─────┨'), nl,
    listingPotion(PIDs, PNames, HPs, ManaS, 1),
    write('\33\[37m\33\[1m'), flush_output,
    write('┗━━━━━┷━━━━┷━━━━━━━━━━━━━━━━━━━━━━━━━━━┷━━━━━┷━━━━━┛'), nl,
    write('\33\[m'), flush_output, !;
    write('\33\[37m\33\[1mKamu tidak memiliki potion\33\[m\n'), !.

%

% -------------- Player stats --------------

checkLevelUp :-
    statPlayer(IDTipe, Nama, CurrentHP, CurrentMana, CurrentAtk, CurrentDef, CurrentLvl, CurrentXP, Gold),
    dodgeChance(DodgeChance), critChance(CritChance), % Intentionally obscure stat

    levelUpXPRequirement(CurrentLvl,XPRequirement),
    XPRequirement =< CurrentXP,
    NewXP is CurrentXP - XPRequirement, LvlUp is CurrentLvl + 1,
    special_skill(IDTipe, SkillName, ManaCost, SkillModifier, Cooldown), % TODO : Add scale
    (
        IDTipe = 'swordsman',
        HPGain is CurrentLvl + 16,
        ManaGain is CurrentLvl + 3,
        AtkGain is 1,
        DefGain is 2,
        (
            CritChance < 99, NewCrit is CurrentLvl // 2 + 5, !;
            NewCrit is 100, !
        ),
        (
            DodgeChance < 99, NewDodge is CurrentLvl // 3 + 5, !;
            NewDodge is 100, !
        ),
        (
            ManaCost > 5, ManaReduction is 1, !;
            ManaReduction is 0, !
        ),
        NewModifier is CurrentLvl // 2 + 10; % Heal 10, upgrade every 2 level

        IDTipe = 'archer',
        HPGain is CurrentLvl + 10,
        ManaGain is CurrentLvl + 1,
        AtkGain is 2,
        DefGain is 1,
        (
            CritChance < 99, NewCrit is CritChance + 1, !;
            NewCrit is 100, !
        ),
        (
            DodgeChance < 99, NewDodge is CurrentLvl // 2 + 15, !;
            NewDodge is 100, !
        ),
        (
            ManaCost > 5, ManaReduction is 1, !;
            ManaReduction is 0, !
        ),
        NewModifier is CurrentLvl // 5 + 2; % Base 2 attack, upgrade every 5 level

        IDTipe = 'sorcerer',
        HPGain is CurrentLvl + 13,
        ManaGain is CurrentLvl + 5,
        AtkGain is 1,
        DefGain is 1,
        (
            CritChance < 99, NewCrit is CurrentLvl // 2 + 8, !; % TODO : Non essential, complete integration of crit dodge
            NewCrit is 100, !
        ),
        (
            DodgeChance < 99, NewDodge is CurrentLvl // 3 + 10, !;
            NewDodge is 100, !
        ),
        (
            ManaCost > 5, ManaReduction is 1, !;
            ManaReduction is 0, !
        ),
        NewModifier is CurrentLvl // 5 + 2 % Multiplier 2, upgrade every 5 level
    ),
    NewHP is CurrentHP + HPGain,
    NewMana is CurrentMana + ManaGain,
    NewAtk is CurrentAtk + AtkGain,
    NewDef is CurrentDef + DefGain,

    CritGain is NewCrit - CritChance,
    DodgeGain is NewDodge - DodgeChance,

    retract(critChance(CritChance)),
    asserta(critChance(NewCrit)),

    retract(dodgeChance(DodgeChance)),
    asserta(dodgeChance(NewDodge)),

    retract(statPlayer(IDTipe, Nama, CurrentHP, CurrentMana, CurrentAtk, CurrentDef, CurrentLvl, CurrentXP, Gold)),
    asserta(statPlayer(IDTipe, Nama, NewHP, NewMana, NewAtk, NewDef, LvlUp, NewXP, Gold)),

    class(ClassID, IDTipe, MaxHP, MaxMP, DefaultAtk, DefaultDef),
    NewMaxHP is MaxHP + HPGain,
    NewMaxMP is MaxMP + ManaGain,
    retract(class(ClassID, IDTipe, MaxHP, MaxMP, DefaultAtk, DefaultDef)),
    asserta(class(ClassID, IDTipe, NewMaxHP, NewMaxMP, DefaultAtk, DefaultDef)),

    retract(special_skill(IDTipe, SkillName, ManaCost, SkillModifier, Cooldown)),
    NewManaCost is ManaCost - ManaReduction,
    asserta(special_skill(IDTipe, SkillName, NewManaCost, NewModifier, Cooldown)),

    format('\n\33\[33m\33\[1mSelamat kamu naik ke level %d!\33\[m\n',[LvlUp]),
    write('\33\[1m\33\[37m'), flush_output,
    write('┏━━━━━━━━━━━━━━━━━━━━┯━━━━━━━━┓\n'),
    format('┃ HP    \33\[31m%4d \33\[32m→ \33\[33m%5d \33\[37m│ \33\[32m↑ \33\[37m%4d ┃\n',[CurrentHP , NewHP , HPGain]),
    format('┃ Mana  \33\[36m%4d \33\[32m→ \33\[33m%5d \33\[37m│ \33\[32m↑ \33\[37m%4d ┃\n',[CurrentMana , NewMana , ManaGain]),
    format('┃ Atk   \33\[m\33\[33m\33\[2m\33\[2m%4d\33\[1m \33\[32m→ \33\[33m%5d \33\[37m│ \33\[32m↑ \33\[37m%4d ┃\n',[CurrentAtk , NewAtk , AtkGain]),
    format('┃ Def   \33\[35m%4d \33\[32m→ \33\[33m%5d \33\[37m│ \33\[32m↑ \33\[37m%4d ┃\n',[CurrentDef , NewDef , DefGain]),
    format('┃ Crit  \33\[m\33\[37m\33\[2m\33\[2m%3d%s\33\[m\33\[1m \33\[32m→  \33\[33m%3d%s \33\[37m│ \33\[32m↑  \33\[37m%2d%s ┃\n',[CritChance, '%', NewCrit, '%', CritGain, '%']),
    format('┃ Dodge \33\[m\33\[37m\33\[2m\33\[2m%3d%s\33\[m\33\[1m \33\[32m→  \33\[33m%3d%s \33\[37m│ \33\[32m↑  \33\[37m%2d%s ┃\n',[DodgeChance, '%', NewDodge, '%', DodgeGain, '%']),
    write('┗━━━━━━━━━━━━━━━━━━━━┷━━━━━━━━┛\n'),

    write('\33\[33mTekan sembarang tombol untuk melanjutkan level up.\33\[m\n'), get_key_no_echo(_),
    checkLevelUp; !.

/* ---------------------------------------------------------------------------------------- */

% Dev note
%statPlayer(IDTipe, Nama, HPPlayer, mana, Atk, DefPlayer, Lvl, XP, NewGold)

% rawAtk(X) :-
%     currentWeapon(X), inventory(X,_,_,_,WAtk,_),
% rawDef(X)

% Weapon, Armor, Misc
