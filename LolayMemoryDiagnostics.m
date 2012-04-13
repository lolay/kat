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

#import "LolayMemoryDiagnostics.h"
#import <mach/mach.h>
#include <sys/types.h>
#include <sys/sysctl.h>

#define BYTES_IN_MB 0x100000

@implementation LolayMemoryDiagnostics

+ (vm_statistics_data_t) retrieveSystemMemoryStatistics {
	mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
	vm_statistics_data_t vmstat;
	host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count);
	return vmstat;
}

+ (int) systemPageSize {
	size_t length;
	int mib[6];
	int pagesize;
	
	mib[0] = CTL_HW;
	mib[1] = HW_PAGESIZE;
	length = sizeof(pagesize);
	sysctl(mib, 2, &pagesize, &length, NULL, 0);
	return pagesize;
}

+ (NSInteger) systemMemoryInMB {
	int pagesize = [LolayMemoryDiagnostics systemPageSize];
	vm_statistics_data_t vmstat = [LolayMemoryDiagnostics retrieveSystemMemoryStatistics];
	return ((vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count) * pagesize) / BYTES_IN_MB;
}

+ (NSInteger) systemFreeMemoryInMB {
	int pagesize = [LolayMemoryDiagnostics systemPageSize];
	vm_statistics_data_t vmstat = [LolayMemoryDiagnostics retrieveSystemMemoryStatistics];
	return (vmstat.free_count * pagesize) / BYTES_IN_MB;
}

+ (NSInteger) systemInactiveMemoryInMB {
	int pagesize = [LolayMemoryDiagnostics systemPageSize];
	vm_statistics_data_t vmstat = [LolayMemoryDiagnostics retrieveSystemMemoryStatistics];
	return (vmstat.inactive_count * pagesize) / BYTES_IN_MB;
}

+ (NSInteger) systemAvailableMemoryInMB {
	return [LolayMemoryDiagnostics systemFreeMemoryInMB] + [LolayMemoryDiagnostics systemInactiveMemoryInMB];
}

+ (Float32) systemPercentFree {
	return (Float32)[LolayMemoryDiagnostics systemFreeMemoryInMB] / (Float32)[LolayMemoryDiagnostics systemMemoryInMB];
}

+ (Float32) systemPercentAvailable {
	return (Float32)[LolayMemoryDiagnostics systemAvailableMemoryInMB] / (Float32)[LolayMemoryDiagnostics systemMemoryInMB];
}

+ (BOOL) systemFreeMemoryIsAvailableInMB:(NSInteger) megabytes {
	return [LolayMemoryDiagnostics systemFreeMemoryInMB] >= megabytes;
}

@end
