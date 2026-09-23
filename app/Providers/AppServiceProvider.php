<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
            date_default_timezone_set('Asia/Jakarta');

            // Force HTTPS in production (Render handles TLS termination)
            if ($this->app->environment('production')) {
                URL::forceScheme('https');
            }
    }
}
