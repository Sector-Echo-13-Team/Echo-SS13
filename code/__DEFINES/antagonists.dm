#define NUKE_RESULT_FLUKE 0
#define NUKE_RESULT_NUKE_WIN 1
#define NUKE_RESULT_CREW_WIN 2
#define NUKE_RESULT_CREW_WIN_SYNDIES_DEAD 3
#define NUKE_RESULT_DISK_LOST 4
#define NUKE_RESULT_DISK_STOLEN 5
#define NUKE_RESULT_WRONG_STATION 6

//fugitive end results
#define FUGITIVE_RESULT_BADASS_HUNTER 0
#define FUGITIVE_RESULT_POSTMORTEM_HUNTER 1
#define FUGITIVE_RESULT_MAJOR_HUNTER 2
#define FUGITIVE_RESULT_HUNTER_VICTORY 3
#define FUGITIVE_RESULT_MINOR_HUNTER 4
#define FUGITIVE_RESULT_STALEMATE 5
#define FUGITIVE_RESULT_MINOR_FUGITIVE 6
#define FUGITIVE_RESULT_FUGITIVE_VICTORY 7
#define FUGITIVE_RESULT_MAJOR_FUGITIVE 8

#define APPRENTICE_DESTRUCTION "destruction"
#define APPRENTICE_BLUESPACE "bluespace"
#define APPRENTICE_ROBELESS "robeless"
#define APPRENTICE_HEALING "healing"

//ERT Types
#define ERT_BLUE "Blue"
#define ERT_RED "Red"
#define ERT_AMBER "Amber"
#define ERT_DEATHSQUAD "Deathsquad"

//ERT subroles
#define ERT_SEC "sec"
#define ERT_MED "med"
#define ERT_ENG "eng"
#define ERT_LEADER "leader"
#define DEATHSQUAD "ds"
#define DEATHSQUAD_LEADER "ds_leader"

//Shuttle elimination hijacking
/// Does not stop elimination hijacking but itself won't elimination hijack
#define ELIMINATION_NEUTRAL 0
/// Needs to be present for shuttle to be elimination hijacked
#define ELIMINATION_ENABLED 1
/// Prevents elimination hijack same way as non-antags
#define ELIMINATION_PREVENT 2

//Syndicate Contracts
#define CONTRACT_STATUS_INACTIVE 1
#define CONTRACT_STATUS_ACTIVE 2
#define CONTRACT_STATUS_BOUNTY_CONSOLE_ACTIVE 3
#define CONTRACT_STATUS_EXTRACTING 4
#define CONTRACT_STATUS_COMPLETE 5
#define CONTRACT_STATUS_ABORTED 6

#define CONTRACT_PAYOUT_LARGE 1
#define CONTRACT_PAYOUT_MEDIUM 2
#define CONTRACT_PAYOUT_SMALL 3

#define CONTRACT_UPLINK_PAGE_CONTRACTS "CONTRACTS"
#define CONTRACT_UPLINK_PAGE_HUB "HUB"
