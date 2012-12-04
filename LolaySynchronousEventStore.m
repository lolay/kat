//
//  Copyright 2012 Lolay, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "LolaySynchronousEventStore.h"

@interface LolaySynchronousEventStore ()

@property (nonatomic) EKEventStore* eventStore;
@property (nonatomic) NSRecursiveLock* lock;

@end

@implementation LolaySynchronousEventStore

#define STARTED 0
#define COMPLETE 1

- (id) init {
	self = [super init];
	if (self) {
		_lock = [[NSRecursiveLock alloc] init];
		_lock.name = @"LolaySynchronousEventStore";
	}
	return self;
}

- (EKEventStore*) eventStore {
	[self.lock lock];
	if (_eventStore == nil) {
		_eventStore = [[EKEventStore alloc] init];
	}
	[self.lock unlock];
	return _eventStore;
}

- (NSArray*) sourcesForEntityType:(EKEntityType) entityType error:(NSError**) error {
	__block NSError* blockError = nil;
	__block NSArray* sources = nil;
	
	NSConditionLock* lock = [[NSConditionLock alloc] initWithCondition:STARTED];
	[self.eventStore requestAccessToEntityType:entityType completion:^(BOOL granted, NSError* accessError) {
		if (accessError) {
			blockError = accessError;
		} else if (granted) {
			sources = self.eventStore.sources;
		} else {
			blockError = [[NSError alloc] initWithDomain:@"Lolay" code:LolayEntityAccessNotGrantedErrorCode userInfo:@{NSLocalizedDescriptionKey: @"Access not granted."}];
		}
		
		[lock unlockWithCondition:COMPLETE];
	}];
	
	[lock lockWhenCondition:COMPLETE]; // Wait for the block to finish
	
	if (blockError) {
		*error = blockError;
		return nil;
	}
	
	return sources;
}

- (NSArray*) calendarsForEntityType:(EKEntityType) entityType error:(NSError**) error {
	__block NSError* blockError = nil;
	__block NSArray* calendars = nil;
	
	NSConditionLock* lock = [[NSConditionLock alloc] initWithCondition:STARTED];
	[self.eventStore requestAccessToEntityType:entityType completion:^(BOOL granted, NSError* accessError) {
		if (accessError) {
			blockError = accessError;
		} else if (granted) {
			calendars = [self.eventStore calendarsForEntityType:entityType];
		} else {
			blockError = [[NSError alloc] initWithDomain:@"Lolay" code:LolayEntityAccessNotGrantedErrorCode userInfo:@{NSLocalizedDescriptionKey: @"Access not granted."}];
		}
		
		[lock unlockWithCondition:COMPLETE];
	}];
	
	[lock lockWhenCondition:COMPLETE]; // Wait for the block to finish
	
	if (blockError) {
		*error = blockError;
		return nil;
	}
	
	return calendars;
}

- (EKCalendar*) createCalendarForEntityType:(EKEntityType) entityType error:(NSError**) error {
	__block NSError* blockError = nil;
	__block EKCalendar* calendar = nil;
	
	NSConditionLock* lock = [[NSConditionLock alloc] initWithCondition:STARTED];
	[self.eventStore requestAccessToEntityType:entityType completion:^(BOOL granted, NSError* accessError) {
		if (accessError) {
			blockError = accessError;
		} else if (granted) {
			calendar = [EKCalendar calendarForEntityType:entityType eventStore:self.eventStore];
		} else {
			blockError = [[NSError alloc] initWithDomain:@"Lolay" code:LolayEntityAccessNotGrantedErrorCode userInfo:@{NSLocalizedDescriptionKey: @"Access not granted."}];
		}
		
		[lock unlockWithCondition:COMPLETE];
	}];
	
	[lock lockWhenCondition:COMPLETE]; // Wait for the block to finish
	
	if (blockError) {
		*error = blockError;
		return nil;
	}
	
	return calendar;
}

- (BOOL) saveCalendar:(EKCalendar*) calendar forEntityType:(EKEntityType) entityType commit:(BOOL) commit error:(NSError**) error {
	__block NSError* blockError = nil;
	__block BOOL success = NO;
	
	NSConditionLock* lock = [[NSConditionLock alloc] initWithCondition:STARTED];
	[self.eventStore requestAccessToEntityType:entityType completion:^(BOOL granted, NSError* accessError) {
		if (accessError) {
			blockError = accessError;
		} else if (granted) {
			success = [self.eventStore saveCalendar:calendar commit:commit error:&blockError];
		} else {
			blockError = [[NSError alloc] initWithDomain:@"Lolay" code:LolayEntityAccessNotGrantedErrorCode userInfo:@{NSLocalizedDescriptionKey: @"Access not granted."}];
		}
		
		[lock unlockWithCondition:COMPLETE];
	}];
	
	[lock lockWhenCondition:COMPLETE]; // Wait for the block to finish
	
	if (blockError) {
		*error = blockError;
		return success;
	}
	
	return success;
}

- (EKReminder*) createReminderWithError:(NSError**) error {
	__block NSError* blockError = nil;
	__block EKReminder* reminder = nil;
	
	NSConditionLock* lock = [[NSConditionLock alloc] initWithCondition:STARTED];
	[self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError* accessError) {
		if (accessError) {
			blockError = accessError;
		} else if (granted) {
			reminder = [EKReminder reminderWithEventStore:self.eventStore];
		} else {
			blockError = [[NSError alloc] initWithDomain:@"Lolay" code:LolayEntityAccessNotGrantedErrorCode userInfo:@{NSLocalizedDescriptionKey: @"Access not granted."}];
		}
		
		[lock unlockWithCondition:COMPLETE];
	}];
	
	[lock lockWhenCondition:COMPLETE]; // Wait for the block to finish
	
	if (blockError) {
		*error = blockError;
		return nil;
	}
	
	return reminder;
}

- (BOOL) saveReminder:(EKReminder*) reminder commit:(BOOL) commit error:(NSError**) error {
	__block NSError* blockError = nil;
	__block BOOL success = NO;
	
	NSConditionLock* lock = [[NSConditionLock alloc] initWithCondition:STARTED];
	[self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError* accessError) {
		if (accessError) {
			blockError = accessError;
		} else if (granted) {
			success = [self.eventStore saveReminder:reminder commit:commit error:&blockError];
		} else {
			blockError = [[NSError alloc] initWithDomain:@"Lolay" code:LolayEntityAccessNotGrantedErrorCode userInfo:@{NSLocalizedDescriptionKey: @"Access not granted."}];
		}
		
		[lock unlockWithCondition:COMPLETE];
	}];
	
	[lock lockWhenCondition:COMPLETE]; // Wait for the block to finish
	
	if (blockError) {
		*error = blockError;
		return success;
	}
	
	return success;
}

- (BOOL) removeReminder:(EKReminder*) reminder commit:(BOOL) commit error:(NSError**) error {
	__block NSError* blockError = nil;
	__block BOOL success = NO;
	
	NSConditionLock* lock = [[NSConditionLock alloc] initWithCondition:STARTED];
	[self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError* accessError) {
		if (accessError) {
			blockError = accessError;
		} else if (granted) {
			success = [self.eventStore removeReminder:reminder commit:commit error:&blockError];
		} else {
			blockError = [[NSError alloc] initWithDomain:@"Lolay" code:LolayEntityAccessNotGrantedErrorCode userInfo:@{NSLocalizedDescriptionKey: @"Access not granted."}];
		}
		
		[lock unlockWithCondition:COMPLETE];
	}];
	
	[lock lockWhenCondition:COMPLETE]; // Wait for the block to finish
	
	if (blockError) {
		*error = blockError;
		return success;
	}
	
	return success;
}

- (NSArray*) fetchRemindersMatchingPredicate:(NSPredicate*) predicate error:(NSError**) error {
	__block NSError* blockError = nil;
	__block NSArray* reminders = nil;
	
	NSConditionLock* lock = [[NSConditionLock alloc] initWithCondition:STARTED];
	[self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError* accessError) {
		if (accessError) {
			blockError = accessError;
		} else if (granted) {
			[self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray* blockReminders) {
				reminders = blockReminders;
			}];
		} else {
			blockError = [[NSError alloc] initWithDomain:@"Lolay" code:LolayEntityAccessNotGrantedErrorCode userInfo:@{NSLocalizedDescriptionKey: @"Access not granted."}];
		}
		
		[lock unlockWithCondition:COMPLETE];
	}];
	
	[lock lockWhenCondition:COMPLETE]; // Wait for the block to finish
	
	if (blockError) {
		*error = blockError;
		return nil;
	}
	
	return reminders;
}

- (NSArray*) fetchRemindersInCalendars:(NSArray*) calendars error:(NSError**) error {
	__block NSError* blockError = nil;
	__block NSArray* reminders = nil;
	
	NSConditionLock* lock = [[NSConditionLock alloc] initWithCondition:STARTED];
	[self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError* accessError) {
		if (accessError) {
			blockError = accessError;
		} else if (granted) {
			NSPredicate* predicate = [self.eventStore predicateForRemindersInCalendars:calendars];
			NSError* fetchError = nil;
			reminders = [self fetchRemindersMatchingPredicate:predicate error:&fetchError];
			if (fetchError) {
				blockError = fetchError;
			}
		} else {
			blockError = [[NSError alloc] initWithDomain:@"Lolay" code:LolayEntityAccessNotGrantedErrorCode userInfo:@{NSLocalizedDescriptionKey: @"Access not granted."}];
		}
		
		[lock unlockWithCondition:COMPLETE];
	}];
	
	[lock lockWhenCondition:COMPLETE]; // Wait for the block to finish
	
	if (blockError) {
		*error = blockError;
		return nil;
	}
	
	return reminders;
}

@end
