Pakyow::App.routes do
  default do
    view.scope(:post).apply(Post.all)
  end
end
