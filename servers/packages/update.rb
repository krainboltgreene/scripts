package :update, provides: :package_update do
  description "Updates apt-get index and packages"
  runner ["apt-get update", "apt-get upgrade -y"]
end
