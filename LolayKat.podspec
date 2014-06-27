Pod::Spec.new do |s|
    s.name              = 'LolayKat'
    s.version           = '1'
    s.summary           = 'Lolay library that adds functionality typically found in UI Kit (i.e. UI Kit Kat :)'
    s.homepage          = 'https://github.com/lolay/kat'
    s.license           = {
        :type => 'Apache',
        :file => 'LICENSE'
    }
    s.author            = {
        'Lolay' => 'support@lolay.com'
    }
    s.source            = {
        :git => 'https://github.com/lolay/kat.git',
        :tag => "1"
    }
    s.source_files      = '*.{h,m}'
    s.requires_arc      = true
	s.frameworks = 'QuartzCore', 'EventKit'
	s.ios.deployment_target = '7.0'
end
