:- dynamic(inventory/6).
:- dynamic(inventoryP/4).
:- dynamic(currentWeapon/1).
:- dynamic(currentArmor/1).
:- dynamic(currentMisc/1).
% :- include('facts.pl').

/*inventory(ItemID, class, category, name, attack, def)*/
addItem(ItemID) :-
    (
    findall(ItemName, inventory(_,_,_,ItemName,_,_), List),
    length(List, Length),
    findall(PotionName, inventoryP(_,PotionName,_,_), ListP),
    length(ListP, LengthP),
    Res is Length+LengthP,
    Res >= 100,
    write('Inventory Is Full'),
    !,fail;

    /*bisa ga ya kira2*/
    ItemID>15,
    potion(ItemID, PotionName, PlusHP, PlusMana),
    asserta(inventoryP(ItemID, PotionName, PlusHP, PlusMana)),!;

    ItemID=<15,
    item(ItemID, Class, Category, ItemName, Attack, Def),
    asserta(inventory(ItemID, Class, Category, ItemName, Attack, Def)),!
    ).


delItem(ItemID) :-
    ItemID>15,
    (
        retract(inventoryP(ItemID,ItemN,_,_)),
        format('\33\[33m\33\[1m%s\33\[37m telah dihapus.\33\[m\n',[ItemN]), !;

        \+inventory(ItemID,_,_,_,_,_),
        write('There is no specified item to delete\n'), !
    ), !;

    ItemID=<15,
    (
        retract(inventory(ItemID,_,_,ItemN,_,_)),
        format('\33\[33m\33\[1m%s\33\[37m telah dihapus.\33\[m\n',[ItemN]), !;

        \+inventoryP(ItemID,_,_,_),
        write('There is no specified potion to delete\n'), !
    ), !.




listing([],[],[],[]).
listing(ListID, List1, List2, List3) :-
    [I1|I2]=ListID,
    [W1|W2]=List1,
    [X1|X2]=List2,
    [Y1|Y2]=List3,
    % format('┃ ID     │ %26d  ┃',[I1]), nl,
    % format('┃ Name   │ \33\[33m\33\[1m%26s\33\[m  ┃',[W1]), nl,
    % format('┃ Attack │ %26d  ┃',[X1]), nl,
    % format('┃ Def    │ %26d  ┃',[Y1]), nl,
    format('\33\[37m\33\[1m┃ %2d │ \33\[33m\33\[1m%-24s\33\[m \33\[37m\33\[1m│ %3d │ %3d ┃',[I1,W1,X1,Y1]), nl,
    % write('┠────────┴────────────────────────────┨'),nl,
    listing(I2, W2, X2, Y2).

listItem :-
    inventory(_,_,_,_,_,_),
    findall(ItemID, inventory(ItemID,_,_,_,_,_), IDs),
    findall(ItemName, inventory(_,_,_,ItemName,_,_), Names),
    findall(Attack, inventory(_,_,_,_,Attack,_), Attacks),
    findall(Def, inventory(_,_,_,_,_,Def), Defs),
    write('\33\[37m\33\[1m'), flush_output,
    write('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓'), nl,
    write('┃                  Weapon                   ┃'), nl,
    write('┠────┬──────────────────────────┬─────┬─────┨'), nl,
    write('┃ ID │ Nama                     │ Atk │ Def ┃'), nl,
    write('┠────┼──────────────────────────┼─────┼─────┨'), nl,
    listing(IDs, Names, Attacks, Defs),
    write('\33\[37m\33\[1m'), flush_output,
    write('┗━━━━┷━━━━━━━━━━━━━━━━━━━━━━━━━━┷━━━━━┷━━━━━┛'), nl,
    write('\33\[m'), flush_output, !;
    write('\33\[37m\33\[1mKamu tidak memiliki item\33\[m\n'), !.

listingPotion([],[],[],[]).
listingPotion(ListID, List1, List2, List3):-
    [I1|I2]=ListID,
    [A1|A2]=List1,
    [B1|B2]=List2,
    [C1|C2]=List3,
    (
        I1 > 15, I1 < 20,
        format('┃ %2d \33\[37m\33\[1m│ \33\[31m\33\[1m%-24s\33\[m \33\[37m\33\[1m│ \33\[31m\33\[1m%3d\33\[m \33\[37m\33\[1m│ \33\[31m\33\[1m%3d\33\[m \33\[37m\33\[1m┃\n',[I1,A1,B1,C1]), !;

        format('┃ %2d \33\[37m\33\[1m│ \33\[36m\33\[1m%-24s\33\[m \33\[37m\33\[1m│ \33\[36m\33\[1m%3d\33\[m \33\[37m\33\[1m│ \33\[36m\33\[1m%3d\33\[m \33\[37m\33\[1m┃\n',[I1,A1,B1,C1]), !
    ),
    % format('┃ ID            │ %19d  ┃',[I1]), nl,
    % format('┃ Name          │ %19s  ┃',[A1]), nl,
    % format('┃ HP Restored   │ %19d  ┃',[B1]), nl,
    % format('┃ Mana Restored │ %19d  ┃',[C1]), nl,
    % write('┃                                      ┃'),nl,
    listingPotion(I2, A2, B2, C2).

listPotion :-
    inventoryP(_,_,_,_),
    findall(PotionID, inventoryP(PotionID,_,_,_), PIDs),
    findall(PotionName, inventoryP(_,PotionName,_,_), PNames),
    findall(PlusHP, inventoryP(_,_,PlusHP,_), HPs),
    findall(PlusMana, inventoryP(_,_,_,PlusMana), ManaS),
    write('\33\[37m\33\[1m'), flush_output,
    write('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓'), nl,
    write('┃                  Potion                   ┃'), nl,
    write('┠────┬──────────────────────────┬─────┬─────┨'), nl,
    write('┃ ID │ Nama                     │ HP  │ MP  ┃'), nl,
    write('┠────┼──────────────────────────┼─────┼─────┨'), nl,
    listingPotion(PIDs, PNames, HPs, ManaS),
    write('\33\[37m\33\[1m'), flush_output,
    write('┗━━━━┷━━━━━━━━━━━━━━━━━━━━━━━━━━┷━━━━━┷━━━━━┛'), nl,
    write('\33\[m'), flush_output, !;
    write('\33\[37m\33\[1mKamu tidak memiliki potion\33\[m\n'), !.

listInventory :-
    listItem,
    listPotion.

%statPlayer(IDTipe, Nama, HPPlayer, mana, Atk, DefPlayer, Lvl, XP, NewGold)

checkLevelUp :-
    statPlayer(IDTipe, Nama, CurrentHP, CurrentMana, CurrentAtk, CurrentDef, CurrentLvl, CurrentXP, Gold),
    critChance(CritChance), % Intentionally obscure stat
    XPToLvlUp is CurrentLvl*20 + 80,
    XPToLvlUp =< CurrentXP,
    NewXP is CurrentXP - XPToLvlUp, LvlUp is CurrentLvl + 1,
    (
        IDTipe = 'swordsman',
        HPGain is CurrentLvl*5 + 40,
        ManaGain is CurrentLvl*3 + 45,
        AtkGain is CurrentLvl//2 + 1,
        DefGain is CurrentLvl//3 + 2,
        CritGain is CurrentLvl//4;

        IDTipe = 'archer',
        HPGain is CurrentLvl*5 + 20,
        ManaGain is CurrentLvl*2 + 10,
        AtkGain is CurrentLvl//2 + 2,
        DefGain is CurrentLvl//3 + 1,
        CritGain is CurrentLvl//2;

        IDTipe = 'sorcerer',
        HPGain is CurrentLvl*5 + 40,
        ManaGain is CurrentLvl*4 + 60,
        AtkGain is CurrentLvl//2 + 1,
        DefGain is CurrentLvl//3 + 1,
        CritGain is CurrentLvl//3
    ),
    NewHP is CurrentHP + HPGain,
    NewMana is CurrentMana + ManaGain,
    NewAtk is CurrentAtk + AtkGain,
    NewDef is CurrentDef + DefGain,
    NewCrit is CritChance + CritGain,

    retract(critChance(CritChance)),
    asserta(critChance(NewCrit)),

    retract(statPlayer(IDTipe, Nama, CurrentHP, CurrentMana, CurrentAtk, CurrentDef, CurrentLvl, CurrentXP, Gold)),
    asserta(statPlayer(IDTipe, Nama, NewHP, NewMana, NewAtk, NewDef, LvlUp, NewXP, Gold)),
    format('\n\33\[33m\33\[1mSelamat kamu naik ke level %d!\33\[m\n',[LvlUp]),
    write('\33\[1m\33\[37m'), flush_output,
    write('┏━━━━━━━━━━━━━━━━━━━━┯━━━━━━━━┓\n'),
    format('┃ HP    \33\[31m%4d \33\[32m→ \33\[33m%5d \33\[37m│ \33\[32m↑ \33\[37m%4d ┃\n',[CurrentHP , NewHP , HPGain]),
    format('┃ Mana  \33\[36m%4d \33\[32m→ \33\[33m%5d \33\[37m│ \33\[32m↑ \33\[37m%4d ┃\n',[CurrentMana , NewMana , ManaGain]),
    format('┃ Atk   \33\[m\33\[33m\33\[2m\33\[2m%4d\33\[1m \33\[32m→ \33\[33m%5d \33\[37m│ \33\[32m↑ \33\[37m%4d ┃\n',[CurrentAtk , NewAtk , AtkGain]),
    format('┃ Def   \33\[35m%4d \33\[32m→ \33\[33m%5d \33\[37m│ \33\[32m↑ \33\[37m%4d ┃\n',[CurrentDef , NewDef , DefGain]),
    format('┃ Crit  \33\[m\33\[37m\33\[2m\33\[2m%3d%s\33\[m\33\[1m \33\[32m→  \33\[33m%3d%s \33\[37m│ \33\[32m↑  \33\[37m%2d%s ┃\n',[CritChance, '%', NewCrit, '%', CritGain, '%']),
    write('┗━━━━━━━━━━━━━━━━━━━━┷━━━━━━━━┛\n'),

    prompt,
    checkLevelUp; !.


% rawAtk(X) :-
%     currentWeapon(X), inventory(X,_,_,_,WAtk,_),
% rawDef(X)


drinkPot :-
    inventoryP(_,_,_,_),
    listPotion,
    write('Masukkan ID Potion \n\33\[32m\33\[1mDrink >> \33\[m'),
    catch(read(X), error(_,_), errorMessage), get_key_no_echo(_),
    usePotion(X), !;
    write('\33\[37m\33\[1mKamu tidak memiliki potion\33\[m\n\n'), !.


equipItem :-
    listItem,
    write('Masukkan ID item yang akan diequip, \n\33\[32m\33\[1mEquip >> \33\[m'),
    catch(read(X), error(_,_), errorMessage),
    equip(X).

% Weapon, Armor, Misc
equip(ItemID) :- % TODO : Extra, Inv sidebar
    currentWeapon(A),
    ItemID =< 9, ItemID > 0,
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
    ItemID > 9, ItemID < 13,
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
    ItemID > 12, ItemID =< 15,
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
    ItemID =< 9, ItemID > 0,
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

    ItemID > 9, ItemID <13,
    statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold),
    inventory(ItemID, Tipe, _, Name, _,ADef),
    (
        asserta(currentArmor(ItemID)),
        NewDef is ADef+Def,
        retract(statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold)),
        asserta(statPlayer(Tipe, Nama, HP, Mana, Atk, NewDef, Lvl, XP, Gold)),
        format('\33\[33m\33\[1m%s\33\[m telah berhasil diequip!\n\n',[Name]),!;

        !
    );

    ItemID > 12, ItemID =< 15,
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
    statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold),
    NewHP is HP+PlusHP,
    NewMana is Mana+PlusMana,
    retract(statPlayer(Tipe, Nama, HP, Mana, Atk, Def, Lvl, XP, Gold)),
    asserta(statPlayer(Tipe, Nama, NewHP, NewMana, Atk, Def, Lvl, XP, Gold)),
    retract(inventoryP(PID, Name, PlusHP, PlusMana)),
    format('\33\[33m\33\[1m%s\33\[m telah diminum\n',[Name]),!;
    write('Potion tidak ditemukan\n').
