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

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

#define LolayEntityAccessNotGrantedErrorCode 1

@interface LolaySynchronousEventStore : NSObject

- (NSArray*) sourcesForEntityType:(EKEntityType) entityType error:(NSError**) error;

- (EKCalendar*) createCalendarForEntityType:(EKEntityType) entityType error:(NSError**) error;
- (NSArray*) calendarsForEntityType:(EKEntityType) entityType error:(NSError**) error;
- (BOOL) saveCalendar:(EKCalendar*) calendar forEntityType:(EKEntityType) entityType commit:(BOOL) commit error:(NSError**) error;

/// Creates a new reminder
- (EKReminder*) createReminderWithError:(NSError**) error;
- (BOOL) saveReminder:(EKReminder*) reminder commit:(BOOL) commit error:(NSError**) error;
- (BOOL) removeReminder:(EKReminder*) reminder commit:(BOOL) commit error:(NSError**) error;

- (NSArray*) fetchRemindersMatchingPredicate:(NSPredicate*) predicate error:(NSError**) error;
- (NSArray*) fetchRemindersInCalendars:(NSArray*) calendars error:(NSError**) error;

@end
