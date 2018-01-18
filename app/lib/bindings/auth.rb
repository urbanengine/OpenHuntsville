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
    end
end