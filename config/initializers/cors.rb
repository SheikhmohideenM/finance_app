Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins "http://localhost:5173" # React dev server for local
    origins do |origin, _env|
      origin =~ %r{\Ahttps://.*\.onrender\.com\z} ||
        origin == "http://localhost:5173" ||
        origin == "http://localhost:3000"
    end

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options ],
      credentials: true
  end
end
