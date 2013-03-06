require 'ostruct'

class Nation
  def self.current
    @nation ||= Nation.new
  end

  def is_shutdown?
    false
  end

  def is_paused?
    false
  end
end

class Page
  def type
    @type ||= Type.new
  end

  def is_deleted?
    false
  end

  def has_rule_violation?
    false
  end

  class Type
    def name
      "Basic"
    end
  end
end

class Request
  def env
    {}
  end

  def xhr?
    false
  end
end

class View
  def html
    yield
  end

  def js
    yield
  end
end

class ActiveRecord
  class RecordNotFound < Exception

  end
end

def current_page
  @current_page ||= Page.new
end

def request
  @request ||= Request.new
end

def params
  @params ||= {}
end

def liquid_arguments

end

def render_liquid

end

def render_liquid_as_widget

end

def respond_to
  yield View.new
end

def logged_in?
  true
end

def is_admin?
  true
end

def admin_streams_path

end

def redirect_to(path)

end

# this is the primary liquid page method, virtually all pages on public NB sites flow through this method.
def show
  if Nation.current.is_paused? && logged_in? && is_admin?
    redirect_to admin_streams_path
    return
  elsif Nation.current.is_shutdown?
    raise ActiveRecord::RecordNotFound
  end

  if current_page.type.name == 'Find Friends'
    find_friends
  end

  if request.env["CURRENT_TAG_SLUG"]
    find_tag
    @page_title = @tag.name + " at " + current_site.name
    @liquid_arguments = liquid_arguments.merge!('tag' => PageTagDrop.new(@tag), 'page_type' => 'Tag')
  elsif !current_page && params[:slug1] # this might be a profile page
    find_profile
    @page_title = @profile.published_name + " at " + current_site.name
    @liquid_arguments = liquid_arguments.merge!('profile' => SignupDrop.new(@profile), 'page_type' => 'Profile')
  elsif !current_page # this is probably a facebook canvas page that doesn't have a page set
    # TODO should probably return some message about embedding page from nationbuilder
    raise ActiveRecord::RecordNotFound
  else
    raise ActiveRecord::RecordNotFound if current_page.is_deleted? || current_page.has_rule_violation?
    if request.env["CURRENT_PAGE_TYPE"] == 'Redirect' || (params[:page_id] && current_page.type.name == 'Redirect')
      # this weird params[:page_id] stuff is to get around the issue if they are accessing the page via ?page_id=283 method as opposed to the slug. it's possible for them to do http://mysite.com/?page_id=20 which the page_finder middleware will pick up as the homepage, but it should actually be whatever page is at id 20.  this will address that.
      if current_page.redirect.attribute_present?("redirect_url")
        redirect_to current_page.redirect.redirect_url && return
      else
        raise ActiveRecord::RecordNotFound
      end
    elsif request.env["CURRENT_PAGE_TYPE"] == 'Moneybomb' || (params[:page_id] && current_page.type.name == 'Moneybomb')
      if current_page.moneybomb.is_active?
        if current_page.moneybomb.attribute_present?("donation_page_id")
          flash[:notice] = "The countdown is over, it's time to donate!"
          redirect_to current_page.moneybomb.donation_page.full_url && return
        elsif current_site.has_donation_page?
          flash[:notice] = "The countdown is over, it's time to donate!"
          redirect_to current_site.donation_page.full_url && return
        end
      end
    elsif request.env["CURRENT_PAGE_TYPE"] == 'ActBlue' || (params[:page_id] && current_page.type.name == 'ActBlue')
      if current_page.actblue.actblue_page_url
        redirect_to current_page.actblue.actblue_page_url_with_tracking && return
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    @liquid_arguments = liquid_arguments

  end

  # this gets around the problem of people sending random .js extensions that have nothing to do with our page slugs
  if request.xhr? && !current_page
    raise ActiveRecord::RecordNotFound
  end

  respond_to do |format|
    format.html { render_liquid }
    format.js { render_liquid_as_widget }
    if request.env["CURRENT_PAGE_TYPE"] == 'Blog'
      format.rss { render :action => :blog, :layout => false }
    elsif request.env["CURRENT_PAGE_TYPE"] == 'Suggestion Box'
      format.rss { render :action => :suggestions, :layout => false }
    end
  end
end


show
