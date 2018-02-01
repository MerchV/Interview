//
//  CoreDataManager.m
//
//  Created by Merch on 2012-10-28.
//
//

#import "CoreDataManager.h"


@interface CoreDataManager()
@property (nonatomic, assign) BOOL needsReset;
@end
@implementation CoreDataManager

- (void)dealloc {

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeStack];
    }
    return self;
}

- (void)initializeStack {
    _managedObjectModel = [self managedObjectModel];
    _coordinator = [self coordinator];
    if(self.needsReset == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ForcedLogOut" object:nil userInfo:@{@"reason": @""}];
        [self resetStack];
        _coordinator = [self coordinator];
    }
    _mainManagedObjectContext = [self mainManagedObjectContext];
}

#pragma mark - Getters

- (NSManagedObjectModel*)managedObjectModel {
    if(!_managedObjectModel) {
//        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil]; // production
        NSURL* url = [[NSBundle bundleForClass:[self class]] resourceURL]; // tests 1
        NSURL* modelURL = [url URLByAppendingPathComponent:@"Model.momd"]; // tests 2
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL]; // tests 3
        NSArray* entities = _managedObjectModel.entities;
        NSAssert(entities.count > 0, @"NO ENTITIES FOUND; MAYBE CAN'T FIND MOMD; MAYBE MISSING FROM COMPILE SOURCES; MAYBE EDIT COREDATAMANAGER.M; MAYBE YOUR MODEL ISN'T NAMED MODEL.MOMD");
    }
    return _managedObjectModel;
}

/*

 errorMergePolicyType
 Default policy for all managed object contexts.


 rollbackMergePolicyType
 A policy that merges conflicts between the persistent store's version of the object and the current in-memory version by discarding all state for the changed objects in conflict.


 overwriteMergePolicyType
 A policy that merges conflicts between the persistent store's version of the object and the current in-memory version by pushing the entire in-memory object to the persistent store.


 mergeByPropertyStoreTrumpMergePolicyType
 A policy that merges conflicts between the persistent store's version of the object and the current in-memory version by individual property, with the in-memory changes trumping external changes.


 mergeByPropertyObjectTrumpMergePolicyType
 A policy that merges conflicts between the persistent store's version of the object and the current in-memory version by individual property, with the external changes trumping in-memory changes.

*/

- (NSManagedObjectContext*)mainManagedObjectContext {
    if(!_mainManagedObjectContext) {
        _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainManagedObjectContext setPersistentStoreCoordinator:self.coordinator];
        _mainManagedObjectContext.automaticallyMergesChangesFromParent = YES;
//        [_mainManagedObjectContext setMergePolicy:NSOverwriteMergePolicyType];
//        [_mainManagedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    return _mainManagedObjectContext;
}

//- (NSManagedObjectContext*)editingManagedObjectContext {
//    if(!_editingManagedObjectContext) {
//        _editingManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
////        [_editingManagedObjectContext setParentContext:self.mainManagedObjectContext];
//        [_editingManagedObjectContext setPersistentStoreCoordinator:self.coordinator];
//        _editingManagedObjectContext.automaticallyMergesChangesFromParent = YES;
////        [_editingManagedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
//    }
//    return _editingManagedObjectContext;
//}

// 134140
// @{NSSQLitePragmasOption: @{@"journal_mode": @"delete"} (if you want to disable WAL)
- (NSPersistentStoreCoordinator*)coordinator {
    if(!_coordinator) {
        NSString* databaseName = @"database.sqlite";
        NSURL* databaseUrl = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:databaseName];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSError* error = nil;
        NSPersistentStore* store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:databaseUrl options:@{NSMigratePersistentStoresAutomaticallyOption:@(YES), NSInferMappingModelAutomaticallyOption:@(YES)} error:&error];

        if(error) {
            if(store == nil) {
                self.needsReset = YES;
            }
            if(_coordinator && _coordinator.persistentStores.count) {
                id store = _coordinator.persistentStores[0];
                NSLog(@"%@", [_coordinator metadataForPersistentStore:store]);
            }
        }
    }
    return _coordinator;
}


#pragma mark - Public methods

- (void)triggerMigration {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _mainManagedObjectContext = self.mainManagedObjectContext;
}

- (nonnull NSManagedObjectContext*)newBackgroundManagedObjectContext {
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:self.coordinator];
//    [context setParentContext:self.mainManagedObjectContext];
//    [context setAutomaticallyMergesChangesFromParent:NO];
    [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    return context;
}

- (void)printEntities {
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
        NSManagedObjectContext* context = (NSManagedObjectContext*)[notification object];
        if(context == self.mainManagedObjectContext) {
            NSString* string = @"";
            NSArray* entities = self.managedObjectModel.entities;
            for(NSEntityDescription* entityDescription in entities) {
                NSString* name = [entityDescription name];
                NSFetchRequest* fetch = [[NSFetchRequest alloc] initWithEntityName:name];
                NSInteger count = [self.mainManagedObjectContext countForFetchRequest:fetch error:nil];
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%@: %ld\n", name, (long)count]];
            }
            NSLog(@">>>\n%@", string);
        }
    }];
}


#pragma mark - Private methods


- (void)resetStack {
//    _managedObjectModel = nil;
    _coordinator = nil;
    _mainManagedObjectContext = nil;
    NSString* databaseName = @"database.sqlite";
    NSURL* databaseUrl = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:databaseName];
    NSError *error = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:databaseUrl.path]) [[NSFileManager defaultManager] removeItemAtURL:databaseUrl error:&error];
    if(error) NSLog(@"%@", [error localizedDescription]);
}

@end
