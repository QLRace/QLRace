# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide HTTP permissions policy. For further
# information see: https://developers.google.com/web/updates/2018/06/feature-policy
#
Rails.application.config.permissions_policy do |f|
  f.accelerometer(:none)
  f.autoplay(:none)
  f.camera(:none)
  f.encrypted_media(:none)
  f.fullscreen(:none)
  f.geolocation(:none)
  f.gyroscope(:none)
  f.magnetometer(:none)
  f.microphone(:none)
  f.midi(:none)
  f.payment(:none)
  f.picture_in_picture(:none)
  f.usb(:none)
end
