//
//  GBCTypes.h
//  GBCDeltaCore
//
//  Created by Riley Testut on 1/30/20.
//  Copyright © 2020 Riley Testut. All rights reserved.
//

#if SWIFT_PACKAGE
@import DeltaTypes;
#else
@import DeltaCore;
#endif

// Extensible Enums
FOUNDATION_EXPORT GameType const GameTypeGBC NS_SWIFT_NAME(gbc);

FOUNDATION_EXPORT CheatType const CheatTypeGameGenie;
FOUNDATION_EXPORT CheatType const CheatTypeGameShark;
