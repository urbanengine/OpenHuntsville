Pakyow::App.bindings :auth do
    scope :auth do
        binding(:email) do
            {
            }
        end

        binding(:verifyemail_action) do
            {
                :action => '/auth/verifyemail/' + bindable.token.to_s
            }
        end

        binding(:forgotpassword_action) do
            {
                :action => '/auth/forgotpassword/' + bindable.token.to_s
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
            {
                :content => 'Verify now >',
                :href => 'https://www.openhuntsville.com/auth/verifyemail/' + bindable.token.to_s
            }
        end

        binding(:forgotpassword_link) do
            {
                :content => 'Reset now >',
                :href => 'https://www.openhuntsville.com/auth/forgotpassword/' + bindable.token.to_s
            }
        end

        binding(:mail_description) do
            {
                :content => bindable.mail_description
            }
        end
    end
end