Pakyow::App.bindings :auth do
    scope :auth do
        binding(:email) do
            {
            }
        end

        binding(:action) do
            {
                :action => '/auth/verifyemail/' + bindable.token.to_s
            }
        end

        binding(:password) do
            {
            }
        end

        binding(:confirmPassword) do
            {
            }
        end

        binding(:verifyemail_link) do
            puts 'bindings'
            puts bindable.inspect
            {
                :content => 'https://www.openhuntsville.com/auth/verifyemail/' + bindable.token.to_s,
                :href => 'https://www.openhuntsville.com/auth/verifyemail/' + bindable.token.to_s
            }
        end

        binding(:passwordreset_link) do
            puts 'bindings'
            puts bindable.inspect
            {
                :content => 'TODO:Tyler edit',
                :href => 'TODO:Tyler edit'
            }
        end
    end
end