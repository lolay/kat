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

#import "UIDevice+Lolay.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation UIDevice (Lolay)

@dynamic macAddress;
@dynamic machine;
@dynamic deviceVersionAsFloat;
@dynamic isIphone5;

- (NSString*) machine {
	size_t size;
	int mib[2] = {CTL_HW, HW_MACHINE};
	sysctl(mib, 2, NULL, &size, NULL, 0);
	char* machine = malloc(size);
	sysctl(mib, 2, machine, &size, NULL, 0);
	NSString* machineString = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
	free(machine);
	return machineString;
}

- (NSString*) macAddress {
    int mgmtInfoBase[6];
    char* msgBuffer = NULL;
    NSString* errorFlag = NULL;
    size_t length;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) {
        errorFlag = @"if_nametoindex failure";
		// Get the size of the data available (store in len)
    } else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) {
        errorFlag = @"sysctl mgmtInfoBase failure";
		// Alloc memory based on above call
    } else if ((msgBuffer = malloc(length)) == NULL) {
        errorFlag = @"buffer allocation failure";
		// Get system information, store in buffer
    } else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0) {
        free(msgBuffer);
        errorFlag = @"sysctl msgBuffer failure";
    } else {
        // Map msgbuffer to interface message structure
        struct if_msghdr* interfaceMsgStruct = (struct if_msghdr*) msgBuffer;
        
        // Map to link-level socket structure
        struct sockaddr_dl* socketStruct = (struct sockaddr_dl*) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        unsigned char macAddress[6];
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        NSString* macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
        
        // Release the buffer memory
        free(msgBuffer);
        
        return macAddressString;
    }
    
    // Error...
    DLog(@"Error: %@", errorFlag);
    
    return nil;
}

- (float)deviceVersionAsFloat {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

- (BOOL) isIphone5 {
    return (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON);
}

- (BOOL) isIpad {
	return [[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound;
}

@end
