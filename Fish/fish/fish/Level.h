//
//  Level.h
//  fish
//
//  Created by NRHVietNam on 4/21/15.
//
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

@property(nonatomic,assign)int level;
@property(nonatomic,assign)int levelPoint;
@property(nonatomic,assign)int levelSpeedFish;
@property(nonatomic,strong)NSMutableArray *levelArrFish;


@end
