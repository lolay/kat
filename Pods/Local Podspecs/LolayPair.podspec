Pod::Spec.new do |s|
    s.name              = 'LolayPair'
    s.version           = '1'
    s.summary           = 'A library for handling key value pairs'
    s.homepage          = 'https://github.com/lolay/pair'
    s.license           = {
        :type => 'Apache',
        :file => 'LICENSE'
    }
    s.author            = {
        'Lolay' => 'support@lolay.com'
    }
    s.source            = {
        :git => 'https://github.com/lolay/pair.git',
        :tag => "1"
    }
    s.source_files      = 'LolayPairGlobals.*','LolayNamePair.*','LolayNumberPair.h.*','LolayStringPair.*','LolayPairTests.*','LolayInvestigo/LolayNSLogTracker.*','LolayInvestigo/LolayNoTracker.*'
    s.requires_arc      = true
	s.frameworks = 'XCTest','Foundation'
	s.ios.deployment_target = '7.0'
	s.xcconfig        = { 'OTHER_LDFLAGS' => '-ObjC'}
end
