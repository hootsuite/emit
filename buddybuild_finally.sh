#!/bin/bash

aws s3 cp s3://hootsuite-build-artifacts/deploy/mobile/iOS/v2/post-build/Dangerfile Dangerfile
chruby 2.3.1
bundle install
bundle exec danger --danger_id=unit_tests

if [[ $BUDDYBUILD_BRANCH == "master" ]]; then
  # Create documentation
  bin/docs -n emit

  # Gather and report coverage stats
  aws s3 cp s3://hootsuite-build-artifacts/deploy/mobile/iOS/v2/post-build/ios-report_coverage bin
  chmod +x bin/ios-report_coverage
  bin/ios-report_coverage -n Emit \
                      -d ${BUDDYBUILD_TEST_DIR} \
                      -s ${BUDDYBUILD_SCHEME} \
                      -u ${SUMOLOGIC_POST_URL}
fi
