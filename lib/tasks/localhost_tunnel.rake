task :tunnel do
  sh "ngrok -subdomain upandsell 3000"
end
