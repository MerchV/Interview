//
//  CoreDataManager.h
//
//  Created by Merch on 2012-10-28.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject
@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext* mainManagedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator* coordinator;
//@property (nonatomic, strong) NSManagedObjectContext* editingManagedObjectContext;
- (void)resetStack;
- (void)triggerMigration;
- (nonnull NSManagedObjectContext*)newBackgroundManagedObjectContext;
- (void)printEntities;
@end

